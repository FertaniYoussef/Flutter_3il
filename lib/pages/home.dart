import 'package:flutter/material.dart';
import 'package:newflutterapp/components/post.dart';
import 'package:newflutterapp/models/post.dart' as models;
import 'package:provider/provider.dart';
import 'package:newflutterapp/providers/post_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.posts;

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        models.Post post = posts[index];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Post(
            post: post,
            shareCount:
                posts.where((aPost) => aPost.embededPost == post).length,
          ),
        );
      },
    );
  }
}
