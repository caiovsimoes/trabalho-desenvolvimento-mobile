import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto/entity/post.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Post>>? listarPosts() {
    try {
      return _db
          .collection('posts')
          .orderBy('hora', descending: true)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => Post.fromFirebase(doc)).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> adicionarPost(Post post) async {
    final newPost = {
      'idUsuario': post.idUsuario,
      'imagemUrl': post.imagemUrl,
      'texto': post.texto,
      'hora': post.hora,
    };

    await _db.collection('posts').add(newPost);
  }

  Future<void> atualizarPost(String id, Post postAtualizado) async {
    await _db.collection('posts').doc(id).update({
      'imagemUrl': postAtualizado.imagemUrl,
      'texto': postAtualizado.texto,
      'hora': postAtualizado.hora,
    });
  }

  Future<void> deletarPost(String id) async {
    await _db.collection('posts').doc(id).delete();
  }

  Stream<List<Post>>? obterPostsPorUsuario(String userId) {
    try {
      return _db
          .collection('posts')
          .where('idUsuario', isEqualTo: userId)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => Post.fromFirebase(doc)).toList());
    } catch (e) {
      print('Erro ao obter posts: $e');
      return null;
    }
  }
}
