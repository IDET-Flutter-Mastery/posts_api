import 'package:flutter/material.dart';
import 'package:rest_api_lab/widgets/error_view.dart';
import 'package:rest_api_lab/widgets/loading_view.dart';

import '../models/post.dart';

/// -----------------------------------------------------------------------
/// CP1 — Your First GET Request (Section 3)
/// -----------------------------------------------------------------------
/// Fetch a single post from your MockAPI resource using the `http`
/// package, decode it into a Post, and show it with a FutureBuilder.
///
/// Type an id into the field below and tap Fetch. Try "1" first.
///
/// -----------------------------------------------------------------------
/// QUICK CHALLENGE — Handle the 404 (Section 5, after the break)
/// -----------------------------------------------------------------------
/// Once CP1 works, come back here and extend the "not OK" branch so a
/// 404 gets its own clear message instead of a generic error. Then type
/// an id that doesn't exist (e.g. "9999") and confirm you see YOUR
/// message, not a raw exception.
/// -----------------------------------------------------------------------
Future<Post> fetchPost(String id) async {
  // 'TODO' (CP1):
  //   1. Build the request URL: '${ApiConfig.baseUrl}/posts/$id'
  //      and parse it with Uri.parse(...).
  //   2. final response = await http.get(uri);
  //   3. If response.statusCode == 200, return
  //      Post.fromJson(jsonDecode(response.body)).
  //      (import 'dart:convert' for jsonDecode)
  //   4. Otherwise, throw Exception('Failed to load post').
  //
  // 'TODO' (Quick Challenge): once step 4 above works, split it into two
  // cases:
  //   if (response.statusCode == 404) {
  //     throw Exception('Post not found');
  //   } else if (response.statusCode != 200) {
  //     throw Exception('Server error: ${response.statusCode}');
  //   }
  throw UnimplementedError('TODO (CP1): implement fetchPost()');
}

class Cp1GetPostScreen extends StatefulWidget {
  const Cp1GetPostScreen({super.key});

  @override
  State<Cp1GetPostScreen> createState() => _Cp1GetPostScreenState();
}

class _Cp1GetPostScreenState extends State<Cp1GetPostScreen> {
  final _idController = TextEditingController(text: '1');
  Future<Post>? _future;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _onFetchPressed() {
    setState(() {
      _future = fetchPost(_idController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CP1 · Fetch a Post')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Post id',
                      hintText: 'e.g. 1, or 9999 for the 404 challenge',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _onFetchPressed,
                  child: const Text('Fetch'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _future == null
                  ? const Center(child: Text('Enter an id and tap Fetch.'))
                  : FutureBuilder<Post>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingView();
                        }
                        if (snapshot.hasError) {
                          return ErrorView(
                            message: '${snapshot.error}',
                            onRetry: _onFetchPressed,
                          );
                        }
                        final post = snapshot.data!;
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'id: ${post.id}',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  post.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'createdAt: ${post.createdAt}',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
