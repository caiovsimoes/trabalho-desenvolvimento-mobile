import 'package:flutter/material.dart';
import 'package:projeto/screens/edit_post.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:projeto/services/post_service.dart';
import 'package:projeto/entity/post.dart';
import 'package:projeto/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  final _postService = PostService();
  late String _userName;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _getUserData();
    // _getUserPosts();
  }

  Future<void> _getUserData() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      setState(() {
        _userName = currentUser.displayName ?? 'Nome não disponível';
        _userEmail = currentUser.email ?? 'Email não disponível';
      });
    }
  }

  void _logout() {
    _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: Container(
        color: const Color(0xFF87CEEB),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedContainer(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dados da Conta',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nome: $_userName',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Email: $_userEmail',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(
                    context,
                    title: 'Editar nome',
                    hint: 'Digite o novo nome ',
                    onSave: (nome, _) {
                      _authService.atualizarNome(nome).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nome alterado com sucesso!'),
                          ),
                        );

                        setState(() {
                          _userName = nome;
                        });
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao alterar o nome!'),
                          ),
                        );
                      });
                    },
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text("Editar nome"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Posts Criados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Post>>(
                stream: _postService
                    .obterPostsPorUsuario(_authService.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar posts.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum post encontrado.'));
                  }

                  final posts = snapshot.data!;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(post.texto),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPostPage(
                                        post: post,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _postService
                                    .deletarPost(post.id!)
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Post deletado com sucesso!'),
                                    ),
                                  );
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Erro ao deletar post!'),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context, {
    required String title,
    required String hint,
    bool isPassword = false,
    bool needPassword = false,
    required Function(String, String?) onSave,
  }) {
    final controller = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: hint),
              obscureText: isPassword,
            ),
            if (needPassword)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: passwordController,
                  decoration:
                      const InputDecoration(hintText: 'Digite sua senha atual'),
                  obscureText: true,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (needPassword) {
                onSave(controller.text, passwordController.text);
              } else {
                onSave(controller.text, null);
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
