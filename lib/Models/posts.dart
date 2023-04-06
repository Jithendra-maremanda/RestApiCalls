class Post {

  final int id;
  final int userId;
  final String title;
  final String body;

  Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  static Map<String, dynamic> toJson(Post value) => {
        'userId': value.userId,
        'title': value.title,
        'body': value.body,
        'id': value.id
      };
}
