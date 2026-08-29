/// -----------------------------------------------------------------------
/// SETUP — do this first, before CP1.
/// -----------------------------------------------------------------------
/// 1. Go to https://mockapi.io and create a free project.
/// 2. Add a resource named "posts" with one extra field: title (string).
///    MockAPI automatically adds `id` and `createdAt` for you.
/// 3. Copy your project's base URL — it looks like:
///      https://<your-id>.mockapi.io/api/v1
/// 4. Paste it below, replacing the placeholder.
/// -----------------------------------------------------------------------
class ApiConfig {
  static const String baseUrl = 'https://REPLACE_ME.mockapi.io/api/v1';
}
