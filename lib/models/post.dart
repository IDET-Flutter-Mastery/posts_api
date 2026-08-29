/// The one data shape used across every checkpoint today.
///
/// This matches the default fields MockAPI gives a "posts" resource
/// with a `title` (string) field added: `id` is always an auto-generated
/// string, and `createdAt` is added automatically too.
///
/// This class is already complete — nothing to do here. Focus your time
/// on the TODOs in network/ and screens/.
class Post {
  final String id;
  final String title;
  final String createdAt;

  Post({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      title: json['title'] as String,
      createdAt: json['createdAt'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        // id and createdAt are assigned by MockAPI — no need to send them.
      };
}
