import 'package:newflutterapp/models/user.dart';

class Post {
  User owner;
  String? content;
  String? image;
  Post? embededPost;
  List<Post> comments;
  List<User> likes;
  String? location;
  String? weather;

  Post({
    required this.owner,
    this.content,
    this.image,
    this.embededPost,
    this.comments = const [],
    this.likes = const [],
    this.location,
    this.weather,
  });
}
