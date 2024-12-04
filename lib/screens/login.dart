import 'package:flutter/material.dart';
import 'package:projeto/screens/register.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:projeto/widgets/widgets.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await _authService
          .login(_loginController.text.trim(), _passwordController.text.trim())
          .then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }).catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer login')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            IntrinsicHeight(
              child: RoundedContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _loginController,
                          decoration:
                              const InputDecoration(labelText: 'E-mail'),
                          validator: (value) =>
                              value!.isEmpty ? 'Informe o e-mail' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Senha'),
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? 'Informe a senha' : null,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text('Entrar'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text('Não tem conta? Cadastre-se'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
