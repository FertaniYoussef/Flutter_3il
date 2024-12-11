import 'package:flutter/material.dart';
import 'package:newflutterapp/models/user.dart';
import 'package:newflutterapp/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:newflutterapp/models/post.dart';
import 'package:newflutterapp/pages/home.dart';
import 'package:newflutterapp/providers/post_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Simulate login setup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).setCurrentUser(
        User(
          username: 'Ernesto',
          avatar:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Che_Guevara_-_Guerrillero_Heroico_by_Alberto_Korda.jpg/800px-Che_Guevara_-_Guerrillero_Heroico_by_Alberto_Korda.jpg',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Fundamentals',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Social Network'),
        ),
        body: const HomePage(), // No need to pass posts
      ),
    );
  }
}

void main() {
  // Create posts
  User shiipou = User(
    username: 'Shiipou',
    avatar: 'https://avatars.githubusercontent.com/u/38187238',
  );

  User github = User(
    username: 'GitHub',
    avatar:
        'https://github.githubassets.com/assets/starstruck-default-b6610abad518.png',
  );

  Post firstPost = Post(
    owner: shiipou,
    content:
        'Laborum magna occaecat anim deserunt est eu exercitation magna ipsum magna adipisicing. Cupidatat aliqua cillum proident culpa officia commodo et. Deserunt veniam aute consequat laborum enim minim sit exercitation irure consequat pariatur eu. Mollit adipisicing dolor do minim commodo commodo elit eiusmod Lorem consectetur occaecat amet.',
    image: 'https://images.unsplash.com/photo-1635365737298-3a64d9459d83',
    likes: [github],
  );

  Post commentAnswer = Post(
    owner: github,
    content:
        'Officia aliqua irure enim excepteur minim pariatur amet incididunt amet. Anim voluptate exercitation enim sit tempor cillum tempor culpa ipsum. Consectetur ipsum tempor voluptate aute.',
  );

  Post commentPost = Post(
    owner: shiipou,
    content:
        'Tempor ad sit id consequat culpa. Ut incididunt consectetur eiusmod ad tempor nostrud cupidatat. Est voluptate dolore aute ex.',
    comments: [commentAnswer],
  );

  Post sharedPost = Post(
    owner: github,
    content:
        'Eiusmod consequat et excepteur Lorem sint ad elit sit exercitation. Veniam ad duis magna veniam aliquip nisi.',
    embededPost: firstPost,
    comments: [commentPost],
    likes: [shiipou],
  );

  List<Post> initialPosts = [firstPost, sharedPost];

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => PostProvider()..addPosts(initialPosts)),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}
