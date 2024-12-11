import 'package:flutter/material.dart';
import 'package:newflutterapp/models/post.dart';
import 'package:newflutterapp/models/user.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  void addPosts(List<Post> posts) {
    _posts.addAll(posts);
    notifyListeners();
  }

  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }

  void likePost(Post post, User user) {
    if (post.likes.contains(user)) {
      post.likes = List.from(post.likes)..remove(user);
    } else {
      post.likes = List.from(post.likes)..add(user);
      print('Likes: ${post.likes.map((e) => e.username)}');
      print('User ${user.username} liked post by ${post.owner.username}');
    }
    notifyListeners();
  }

  void addComment(Post post, Post comment) {
    post.comments = List.from(post.comments)..add(comment);
    print(
        'User ${comment.owner.username} commented on post by ${post.owner.username}');
    print('Comments: ${post.comments.map((e) => e.owner.username)}');
    notifyListeners();
  }

  void incrementShareCount(Post post) {
    final index = posts.indexOf(post);
    if (index != -1) {
      posts[index] = Post(
        owner: posts[index].owner,
        content: posts[index].content,
        image: posts[index].image,
        embededPost: posts[index].embededPost,
        comments: posts[index].comments,
        likes: posts[index].likes,
     
      );
      notifyListeners();
    }
  }
}
