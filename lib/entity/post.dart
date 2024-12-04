import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String texto;
  final String? imagemUrl;
  String? idUsuario;
  final Timestamp hora;

  Post({
    this.id,
    required this.texto,
    this.imagemUrl,
    this.idUsuario,
    required this.hora,
  });

  factory Post.fromFirebase(DocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data()! as Map<String, dynamic>;

    return Post(
      id: snapshot.id,
      texto: data['texto'],
      imagemUrl: data['imagemUrl'],
      idUsuario: data['idUsuario'],
      hora: data['hora'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'texto': texto,
      'idUsuario': idUsuario,
      'imagemUrl': imagemUrl,
      'hora': hora
    };
  }
}
