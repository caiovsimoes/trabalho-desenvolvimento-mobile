import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? id;
  final String usuario;
  final String senha;
  final String nome;

  Usuario({
    this.id,
    required this.nome,
    required this.usuario,
    required this.senha,
  });

  factory Usuario.fromFirebase(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return Usuario(
      id: snapshot.id,
      nome: data['nome'],
      usuario: data['usuario'],
      senha: data['senha'],
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    try {
      return Usuario(
        id: json['id'],
        nome: json['nome'],
        usuario: json['usuario'],
        senha: json['senha'],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'usuario': usuario,
    };
  }
}
