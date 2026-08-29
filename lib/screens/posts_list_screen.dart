import 'package:flutter/material.dart';
import 'package:rest_api_lab/theme/app_theme.dart';
import 'package:rest_api_lab/widgets/error_view.dart';
import 'package:rest_api_lab/widgets/loading_view.dart';

import '../models/post.dart';
// 'TODO' (CP4): once network/api_service.dart is implemented, uncomment:
// import '../network/api_service.dart';

/// -----------------------------------------------------------------------
/// CP3 — End-to-End: MockAPI → List View (Section 7)
/// -----------------------------------------------------------------------
/// Fetch every post from your MockAPI resource with `dio`, and render it
/// in a scrollable list. If you completed CP2, watch the console when
/// this screen opens — you should see your interceptor's log lines.
/// -----------------------------------------------------------------------
Future<List<Post>> fetchPosts() async {
  // 'TODO' (CP3):
  //   1. final response = await dio.get('/posts');
  //   2. response.data is already-decoded — cast it to a List and map
  //      each element through Post.fromJson, then .toList().
  throw UnimplementedError('TODO (CP3): implement fetchPosts()');
}

/// -----------------------------------------------------------------------
/// CP4 — Refactor onto the Reusable Network Layer (Section 7)
/// -----------------------------------------------------------------------
/// Once network/api_service.dart compiles:
///   1. Uncomment the import at the top of this file.
///   2. In _PostsListScreenState._load() below, replace
///      `_postsFuture = fetchPosts();` with
///      `_postsFuture = ApiService.instance.getPosts();`
///   3. The loose fetchPosts() function above is no longer called by the
///      UI — you can leave it for reference or delete it.
/// Same UI, cleaner architecture: the screen no longer knows dio exists.
/// -----------------------------------------------------------------------
///
/// -----------------------------------------------------------------------
/// BONUS (Final Exercise) — Create + Pull to Refresh
/// -----------------------------------------------------------------------
///   1. Wrap the ListView.builder below in a RefreshIndicator whose
///      onRefresh calls _load() (it already reassigns _postsFuture and
///      calls setState for you — see below).
///   2. Add a FloatingActionButton that opens a small dialog/text field,
///      builds a Post, and calls ApiService.instance.createPost(post).
///      On success, refresh the list by calling _load() again.
/// -----------------------------------------------------------------------

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Kicks off (or re-kicks-off) the fetch. Pulled into its own method
  /// so both `initState()` and the error view's "Try again" button — and,
  /// once you build it, the Bonus RefreshIndicator — can all share the
  /// exact same reload logic instead of three near-identical copies.
  void _load() {
    setState(() {
      _postsFuture = fetchPosts();
      // 'TODO' (CP4): swap the line above for:
      // _postsFuture = ApiService.instance.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CP3+CP4 · Posts Feed')),
      // 'TODO' (Bonus): wrap this FutureBuilder in a RefreshIndicator.
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: '${snapshot.error}',
              onRetry: _load,
            );
          }
          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(
                  'Created: ${post.createdAt}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.sage.withValues(alpha: 0.12),
                  foregroundColor: AppColors.sageDeep,
                  child: Text('${index + 1}'),
                ),
              );
            },
          );
        },
      ),
      // 'TODO' (Bonus): add a FloatingActionButton here that creates a new
      // post via ApiService.instance.createPost(...) and refreshes the
      // list by calling _load() again.
    );
  }
}
