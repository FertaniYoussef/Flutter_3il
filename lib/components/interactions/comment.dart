import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final int commentCount;
  final VoidCallback onComment;

  const Comment({
    super.key,
    required this.onComment,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IconButton(
        onPressed: onComment,
        icon: const Icon(Icons.comment),
        tooltip: "Comment",
      ),
      Text('$commentCount'),
    ]);
  }
}
