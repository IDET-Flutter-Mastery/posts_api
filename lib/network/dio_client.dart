import 'package:dio/dio.dart';

import 'api_config.dart';

/// One shared Dio instance for the whole app.
///
/// CP3's posts_list_screen.dart calls this same `dio` object — so once you
/// add an interceptor here for CP2, you'll see its log lines in the
/// console the moment you open the Posts Feed screen. No extra wiring
/// needed.
final Dio dio = Dio(
  BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ),
);

/// -----------------------------------------------------------------------
/// CP2 — Interceptors
/// -----------------------------------------------------------------------
/// Call `dio.interceptors.add(...)` below with an InterceptorsWrapper that:
///   1. onRequest  — attaches a fake Authorization header and prints the
///                   outgoing method + path.
///   2. onResponse — prints the returned status code.
///   3. onError    — prints the error message.
///
/// Remember: every hook must call handler.next(...) to let the request
/// continue through the pipeline.
///
/// Example shape (fill in the prints / header):
///
/// dio.interceptors.add(
///   InterceptorsWrapper(
///     onRequest: (options, handler) {
///       // options.headers['Authorization'] = 'Bearer demo-token';
///       // print('→ ${options.method} ${options.path}');
///       return handler.next(options);
///     },
///     onResponse: (response, handler) {
///       // print('← ${response.statusCode}');
///       return handler.next(response);
///     },
///     onError: (error, handler) {
///       // print('✕ ${error.message}');
///       return handler.next(error);
///     },
///   ),
/// );
/// -----------------------------------------------------------------------
void setupInterceptors() {
  // 'TODO' (CP2): add your InterceptorsWrapper to dio.interceptors here.
}
