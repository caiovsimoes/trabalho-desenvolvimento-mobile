import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:projeto/entity/post.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:projeto/widgets/widgets.dart';

import '../services/post_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _postService = PostService();
  final _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _base64Image;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);

        setState(() {
          _imageBytes = bytes;
          _base64Image = base64Image;
        });
      }
    } catch (e) {
      print("Erro ao selecionar imagem: $e");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final postContent = _contentController.text;

      Post newPost = Post(
        texto: postContent,
        hora: Timestamp.now(),
        idUsuario: _authService.currentUser!.uid,
        imagemUrl: _base64Image,
      );

      await _postService.adicionarPost(newPost).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post criado com sucesso!')),
        );

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: const Color(0xFF4682B4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: RoundedContainer(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conteúdo do Post:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _contentController,
                        maxLength: 280,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Digite o conteúdo do seu post...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O conteúdo do post não pode estar vazio.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_imageBytes != null)
                        Center(
                          child: Column(
                            children: [
                              if (_imageBytes != null)
                                Image.memory(_imageBytes!,
                                    height: 200, fit: BoxFit.cover),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _imageBytes = null;
                                    _base64Image = null;
                                  });
                                },
                                child: const Text('Remover imagem'),
                              ),
                            ],
                          ),
                        ),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text('Adicionar Imagem'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Postar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFF87CEEB),
  //     appBar: AppBar(
  //       title: const Text('Criar Post'),
  //       backgroundColor: const Color(0xFF4682B4),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               'Conteúdo do Post:',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             TextFormField(
  //               controller: _contentController,
  //               maxLength: 280,
  //               maxLines: 5,
  //               decoration: const InputDecoration(
  //                 hintText: 'Digite o conteúdo do seu post...',
  //                 border: OutlineInputBorder(),
  //               ),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'O conteúdo do post não pode estar vazio.';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             const SizedBox(height: 16),
  //             if (_imageBytes != null)
  //               Column(
  //                 children: [
  //                   if (_imageBytes != null)
  //                     Image.memory(_imageBytes!,
  //                         height: 200, fit: BoxFit.cover),
  //                   TextButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         _imageBytes = null;
  //                         _base64Image = null;
  //                       });
  //                     },
  //                     child: const Text('Remover imagem'),
  //                   ),
  //                 ],
  //               ),
  //             OutlinedButton.icon(
  //               onPressed: _pickImage,
  //               icon: const Icon(Icons.image),
  //               label: const Text('Adicionar Imagem'),
  //             ),
  //             const SizedBox(height: 24),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: _submitForm,
  //                 child: const Text('Postar'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
