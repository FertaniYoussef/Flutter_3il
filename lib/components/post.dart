import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newflutterapp/components/interactions/interactions.dart';
import 'package:newflutterapp/components/miniprofile.dart';
import 'package:newflutterapp/components/shared_post.dart';
import 'package:newflutterapp/models/post.dart' as models;
import 'package:newflutterapp/providers/post_provider.dart';
import 'package:newflutterapp/pages/comment_page.dart';
import 'package:newflutterapp/providers/user_provider.dart';

class Post extends StatelessWidget {
  final models.Post post;
  final int shareCount;
  final bool isComment;

  const Post(
      {super.key,
      required this.post,
      this.shareCount = 0,
      this.isComment = false});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    // Listen to PostProvider and find the updated version of this post
    final postProvider = Provider.of<PostProvider>(context);
    final updatedPost = postProvider.posts.firstWhere(
      (p) =>
          p.owner == post.owner &&
          p.content == post.content &&
          p.image == post.image,
      orElse: () => post,
    );

    final isLiked =
        currentUser != null && updatedPost.likes.contains(currentUser);
    final likeCount = updatedPost.likes.length;

    Widget postContent = Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiniProfile(user: updatedPost.owner),
          if (isComment)
            Text(
              'En réponse à ${updatedPost.owner.username}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          if (updatedPost.content != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                updatedPost.content!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          if (updatedPost.image != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, updatedPost.image!),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      updatedPost.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/default_image.jpg');
                      },
                    ),
                  ),
                ),
              ),
            ),
          if (post.location != null && post.weather != null) ...[
            const SizedBox(height: 10),
            Text(
              'Location: ${post.location}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Weather: ${post.weather}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
          if (updatedPost.embededPost != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SharedPost(post: updatedPost.embededPost!),
            ),
          const SizedBox(height: 10),
          Interactions(
            likeCount: likeCount,
            commentCount: updatedPost.comments.fold(0, _getNbComments),
            shareCount: shareCount,
            onLike: () => onLike(context),
            onComment: () => onComment(context),
            onShare: () => onShare(context),
            isLiked: isLiked,
            isComment: isComment,
          ),
          ...updatedPost.comments.map((comment) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey[400]!, width: 1),
                    ),
                  ),
                  child: Post(post: comment, isComment: true),
                ),
              )),
        ],
      ),
    );

    if (isComment) {
      postContent = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 2, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: postContent),
        ],
      );
    }

    return postContent;
  }

  void onLike(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      postProvider.likePost(post, userProvider.currentUser!);
    }
  }

  void onComment(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    if (currentUser != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddCommentPage(
            post: post,
            onCommentAdded: (newComment) {
              postProvider.addComment(post, newComment);
            },
          ),
        ),
      );
    }
  }

  void onShare(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      // Create a new post with the current user as the sharer
      final sharedPost = models.Post(
        owner: currentUser,
        content: "Shared a post from ${post.owner.username}",
        image: null, // The shared post might not have a new image
        embededPost: post, // Embedding the original post
        comments: [],
        likes: [],
      );

      // Add the new shared post to the post provider
      postProvider.addPost(sharedPost);

      // Increment the share count of the original post
      postProvider.incrementShareCount(post);

      // Provide feedback to the user (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post shared successfully!')),
      );
    }
  }

  int _getNbComments(int value, models.Post aPost) {
    return aPost.comments.fold(value, _getNbComments) + 1;
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black54,
        child: Stack(
          children: [
            Center(child: Image.network(imageUrl)),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
