import 'package:flutter/material.dart';
import 'package:newflutterapp/models/post.dart' as models;
import 'package:newflutterapp/models/user.dart' as models;

class AddCommentPage extends StatelessWidget {
  final models.Post post;
  final Function(models.Post newComment) onCommentAdded;

  AddCommentPage({
    required this.post,
    required this.onCommentAdded,
  });
  // Simulating a static current user (replace with your static user data)
  final models.User currentUser = models.User(
      username: "StaticUser", avatar: "https://via.placeholder.com/150");

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final ValueNotifier<String?> imageUrlNotifier =
        ValueNotifier<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Répondre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 50.0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'En réponse à ${post.owner.username}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(post.content ?? '',
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
              thickness: 1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre commentaire',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: imageUrlNotifier,
              builder: (context, imageUrl, child) {
                return imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 120,
                              height: 60,
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                imageUrlNotifier.value = null;
                              },
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 0,
              thickness: 1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  // Logic to add image URL
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: const Text(
                          'Ajouter une URL d\'image',
                          style: TextStyle(color: Colors.black),
                        ),
                        content: TextField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            hintText: 'Entrez l\'URL de l\'image',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Annuler',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              imageUrlNotifier.value = imageController.text;
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Ajouter',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    final newComment = models.Post(
                      owner: currentUser,
                      content: commentController.text,
                      image: imageUrlNotifier.value,
                    );

                    // Call the callback to add the comment
                    onCommentAdded(newComment);

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
