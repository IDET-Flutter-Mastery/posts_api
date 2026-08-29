import '../models/post.dart';

/// -----------------------------------------------------------------------
/// CP4 — Building the Reusable Network Layer
/// -----------------------------------------------------------------------
/// Goal: give the whole app ONE front door to the network, instead of
/// screens calling `dio` directly.
///
/// Steps:
///   1. Keep this as a singleton — `ApiService.instance` is the only way
///      to get one, matching the private constructor below.
///   2. Implement getPosts(): call dio.get('/posts'), and map the
///      response's List<dynamic> into a List<Post> using Post.fromJson.
///   3. Implement createPost(): call dio.post('/posts', data: post.toJson()),
///      and return Post.fromJson(response.data).
///   4. Once both compile, go back to screens/posts_list_screen.dart and
///      replace its call to the loose fetchPosts() function with
///      ApiService.instance.getPosts(). Same UI, cleaner architecture.
/// -----------------------------------------------------------------------
class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  Future<List<Post>> getPosts() async {
    // 'TODO' (CP4): call dio.get('/posts') and map response.data (a List)
    // into List<Post> using Post.fromJson for each item.
    throw UnimplementedError('TODO (CP4): implement getPosts()');
  }

  Future<Post> createPost(Post post) async {
    // 'TODO' (Bonus): call dio.post('/posts', data: post.toJson()) and
    // return Post.fromJson(response.data).
    throw UnimplementedError('TODO (Bonus): implement createPost()');
  }
}
