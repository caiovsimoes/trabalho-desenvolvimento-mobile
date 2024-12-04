import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto/entity/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(Usuario user) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: user.usuario,
      password: user.senha,
    );

    await userCredential.user!.updateProfile(displayName: user.nome);
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<void> atualizarNome(String nome) async {
    await currentUser!.updateDisplayName(nome);
  }
}
