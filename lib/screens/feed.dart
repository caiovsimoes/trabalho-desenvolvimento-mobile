import 'package:projeto/entity/post.dart';
import 'package:projeto/services/post_service.dart';
import 'package:projeto/widgets/post_widget.dart';
import 'package:projeto/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: _postService.listarPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os posts'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const RoundedContainer(
            height: 30,
            child: Center(child: Text("Nenhum post foi criado ainda!")),
          );
        } else {
          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostWidget(post: posts[index]);
            },
          );
        }
      },
    );
  }
}
