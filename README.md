# REST API Lab — http, dio, MockAPI & a Reusable Network Layer

A small Flutter lab for practicing three ways of talking to a REST
API: the low-level `http` package, `dio` with interceptors, and a
clean singleton network layer (`ApiService`) that keeps screens from
knowing which HTTP client they're built on at all.

Every checkpoint talks to a real (but tiny, free) backend you create
yourself on [MockAPI](https://mockapi.io) — there's no bundled mock
server, so **do the Setup section before CP1**.

## Screenshots

<!--
  Placeholder paths — this README was generated without a device or
  emulator to run the app on, so these aren't real screenshots yet.
  Run the app, capture the Home menu and the Posts Feed (once CP3
  works), and drop the two images at the paths below (or swap in
  hosted image URLs) so they render here.
-->

| Home menu | Posts Feed |
|---|---|
| ![Home menu screen](docs/screenshots/home_menu_screen.png) | ![Posts feed screen](docs/screenshots/posts_list_screen.png) |

---

## Before you start

### Setup — do this first

1. Go to [mockapi.io](https://mockapi.io) and create a free project.
2. Add a resource named **`posts`** with one extra field: `title`
   (string). MockAPI automatically adds `id` and `createdAt` for you.
3. Copy your project's base URL — it looks like
   `https://<your-id>.mockapi.io/api/v1`.
4. Paste it into `lib/network/api_config.dart`, replacing the
   placeholder:

   ```dart
   class ApiConfig {
     static const String baseUrl = 'https://<your-id>.mockapi.io/api/v1';
   }
   ```

### Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.0.0
  dio: ^5.0.0
  google_fonts: ^6.0.0
```

Run `flutter pub get`, then `flutter run`. The app opens on a **Home
menu** that links to each checkpoint's screen — nothing to build
there, it's done. Use it to jump straight to whichever checkpoint
you're working on instead of navigating there manually.

### What's already built for you

- **`lib/theme/app_theme.dart`** — the whole visual theme (Josefin
  Sans, the indigo "developer console" accent that matches the
  lecture slides). You never need to touch this.
- **`lib/screens/home_menu_screen.dart`** — the navigation hub. Done.
- **`lib/models/post.dart`** — the `Post` model, with `fromJson` and
  `toJson` already written. Done — every checkpoint below decodes
  JSON *into* this class or encodes it *from* this class; you never
  edit the class itself.
- **`lib/widgets/loading_view.dart`** / **`error_view.dart`** —
  `LoadingView` and `ErrorView` are the shared "spinner" and
  "something went wrong, with a Try Again button" states used by
  every `FutureBuilder` in the app. They're purely presentational —
  `ErrorView` just displays whatever string your fetch function's
  exception carries, so writing a better error message in the Quick
  Challenge below will show up here automatically.

Every TODO you'll work through is tagged `CP1`–`CP4` (plus a **Quick
Challenge** and a final **Bonus**) directly in the source files. Work
through them **in order** — later checkpoints assume earlier ones are
done.

---

## CP1 — Your first GET request (Section 3)

**File:** `lib/screens/cp1_get_post_screen.dart`
**Goal:** fetch a single post by id using the `http` package, decode
it into a `Post`, and display it.

Open the Home menu → **CP1 + Quick Challenge**. Right now typing an id
and tapping Fetch just throws `UnimplementedError`.

**Steps**, inside the `fetchPost(String id)` function at the top of
the file:

1. Build the request URL and parse it:

   ```dart
   final uri = Uri.parse('${ApiConfig.baseUrl}/posts/$id');
   ```

2. Make the request:

   ```dart
   final response = await http.get(uri);
   ```

3. On success, decode the body and build a `Post`:

   ```dart
   if (response.statusCode == 200) {
     return Post.fromJson(jsonDecode(response.body));
   }
   ```

   You'll need `import 'dart:convert';` at the top of the file for
   `jsonDecode`.

4. Handle everything else:

   ```dart
   throw Exception('Failed to load post');
   ```

**Check yourself:** type `1` and tap Fetch — you should see a card
with the post's id, title, and createdAt. The loading spinner and
error state are already wired up (`LoadingView` / `ErrorView`) — you
only need `fetchPost` to actually return or throw.

---

## Quick Challenge — Handle the 404 (Section 5)

**File:** same as CP1, same `fetchPost` function.

Once CP1 works, type an id that doesn't exist (e.g. `9999`). Right
now you'll see a generic `Exception: Failed to load post` — technically
correct, but not a great message for a "not found" case specifically.

**Steps:** split step 4 above into two branches:

```dart
if (response.statusCode == 404) {
  throw Exception('Post not found');
} else if (response.statusCode != 200) {
  throw Exception('Server error: ${response.statusCode}');
}
```

**Check yourself:** id `9999` should now show **"Post not found"** —
your own message, not a raw exception — inside the same `ErrorView`
you already saw in CP1, complete with its "Try again" button.

---

## CP2 — Interceptors (Section 6)

**File:** `lib/network/dio_client.dart`
**Goal:** see every outgoing request and incoming response logged to
the console, without touching the screens that make those requests.

There's no dedicated screen for this checkpoint — the Home menu's
"CP2 — Interceptors" card is disabled on purpose; you'll verify this
one by watching the console when you open the Posts Feed (CP3) below.

**Steps**, inside `setupInterceptors()`:

```dart
void setupInterceptors() {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer demo-token';
        print('→ ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('← ${response.statusCode}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('✕ ${error.message}');
        return handler.next(error);
      },
    ),
  );
}
```

**The one rule that trips people up:** every hook — `onRequest`,
`onResponse`, `onError` — must call `handler.next(...)`. Skip it and
the request just hangs forever, because nothing tells Dio's pipeline
to continue.

**Check yourself:** `setupInterceptors()` is already called once in
`main.dart` before the app even starts, so there's nothing extra to
wire up. Once CP3 is also done, opening the Posts Feed screen should
print a `→ GET /posts` / `← 200` pair to your console.

---

## CP3 — End to end: MockAPI → list view (Section 7)

**File:** `lib/screens/posts_list_screen.dart`
**Goal:** fetch every post with `dio` and render it as a scrollable
list.

Open the Home menu → **CP3 + CP4 — Posts Feed**.

**Steps**, inside the `fetchPosts()` function at the top of the file:

```dart
Future<List<Post>> fetchPosts() async {
  final response = await dio.get('/posts');
  return (response.data as List)
      .map((json) => Post.fromJson(json))
      .toList();
}
```

Unlike `http`, `dio` decodes the JSON body for you — `response.data`
is already a `List<dynamic>` (or a `Map`, for a single-object
response), not a raw string. That's the main difference to notice
between this and CP1.

**Check yourself:** the Posts Feed should show one row per post in
your MockAPI resource, each with a numbered indigo avatar, the title,
and its `createdAt`. If you finished CP2, check your console too —
you should see the interceptor's log lines the moment this screen
opens.

---

## CP4 — Refactor onto the reusable network layer (Section 7)

**File:** `lib/network/api_service.dart`, then back to
`posts_list_screen.dart`
**Goal:** give the whole app one shared "front door" to the network —
`ApiService.instance` — instead of screens calling `dio` directly.

**Why this matters:** right now, `posts_list_screen.dart` knows `dio`
exists — it imports `dio_client.dart` and calls `dio.get(...)`
directly. That's fine for a one-screen lab, but in a real app with a
dozen screens, "which HTTP client, base URL, and error handling do
I use" becomes a decision made a dozen times instead of once.
`ApiService` is that one decision, made once.

**Steps**, inside `network/api_service.dart`:

1. Implement `getPosts()` — this is the same logic as CP3's
   `fetchPosts()`, just living in a class instead of a loose function:

   ```dart
   Future<List<Post>> getPosts() async {
     final response = await dio.get('/posts');
     return (response.data as List)
         .map((json) => Post.fromJson(json))
         .toList();
   }
   ```

2. Implement `createPost()` (you'll actually call this one in the
   Bonus section):

   ```dart
   Future<Post> createPost(Post post) async {
     final response = await dio.post('/posts', data: post.toJson());
     return Post.fromJson(response.data);
   }
   ```

3. Back in `posts_list_screen.dart`:
   - Uncomment the import at the top:
     `import '../network/api_service.dart';`
   - In `_PostsListScreenState._load()`, replace
     `_postsFuture = fetchPosts();` with
     `_postsFuture = ApiService.instance.getPosts();`

**Check yourself:** same UI, same list — if it still shows your
posts after switching to `ApiService.instance.getPosts()`, CP4 is
done. The loose `fetchPosts()` function at the top of the file is no
longer called by the UI at that point; you can leave it for
reference or delete it.

`ApiService` stays a singleton on purpose — `ApiService._internal()`
is private, so `ApiService.instance` is the *only* way to get one.
That guarantees every screen in the app shares the exact same
instance (and therefore the same `dio` client, same interceptors,
same everything) rather than each screen quietly creating its own.

---

## Bonus (final exercise) — Create + pull to refresh

**File:** `lib/screens/posts_list_screen.dart`

Two small features, both building on CP4:

1. **Pull to refresh.** Wrap the `ListView.separated` in a
   `RefreshIndicator` whose `onRefresh` calls `_load()` — the reload
   helper already exists in `_PostsListScreenState` (it's what the
   error state's "Try again" button already calls), so this step is
   mostly about the `RefreshIndicator` widget itself:

   ```dart
   body: RefreshIndicator(
     onRefresh: () async => _load(),
     child: FutureBuilder<List<Post>>( /* ...unchanged... */ ),
   ),
   ```

2. **Create a post.** Add a `FloatingActionButton` to the `Scaffold`
   that opens a small dialog with a text field, builds a `Post` from
   the entered title, calls `ApiService.instance.createPost(post)`,
   and — on success — calls `_load()` again so the new post shows up
   immediately.

   A minimal version of the dialog:

   ```dart
   floatingActionButton: FloatingActionButton(
     onPressed: () async {
       final controller = TextEditingController();
       final title = await showDialog<String>(
         context: context,
         builder: (context) => AlertDialog(
           title: const Text('New post'),
           content: TextField(
             controller: controller,
             decoration: const InputDecoration(labelText: 'Title'),
           ),
           actions: [
             TextButton(
               onPressed: () => Navigator.of(context).pop(),
               child: const Text('Cancel'),
             ),
             TextButton(
               onPressed: () => Navigator.of(context).pop(controller.text),
               child: const Text('Create'),
             ),
           ],
         ),
       );
       if (title != null && title.trim().isNotEmpty) {
         await ApiService.instance.createPost(Post(
           id: '', // ignored — toJson() doesn't send id
           title: title.trim(),
           createdAt: '', // ignored — toJson() doesn't send createdAt
         ));
         _load();
       }
     },
     child: const Icon(Icons.add),
   ),
   ```

**Check yourself:** pulling down on the list should show a refresh
spinner and re-fetch; tapping the FAB, typing a title, and tapping
Create should add a real row to your MockAPI resource *and* show up
in the list immediately after.

---

## Quick reference — checkpoint summary

| Checkpoint | What you add | File(s) |
|---|---|---|
| CP1 | `fetchPost()` using `http` | `screens/cp1_get_post_screen.dart` |
| Quick Challenge | A dedicated 404 message | same file, same function |
| CP2 | An `InterceptorsWrapper` | `network/dio_client.dart` |
| CP3 | `fetchPosts()` using `dio` | `screens/posts_list_screen.dart` |
| CP4 | `ApiService.getPosts()` + `createPost()`, then switch the screen over | `network/api_service.dart`, `screens/posts_list_screen.dart` |
| Bonus | Pull to refresh + create-post FAB | `screens/posts_list_screen.dart` |