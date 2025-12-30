import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login Evac Map',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              // GOOGLE LOGIN
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Login dengan Google'),
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        try {
                          await auth.signInWithGoogle();
                        } catch (e) {
                          _error(context, e.toString());
                        }
                      },
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailC,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) =>
                          v == null || !v.contains('@') ? 'Email tidak valid' : null,
                    ),
                    TextFormField(
                      controller: passC,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (v) =>
                          v == null || v.length < 6 ? 'Min 6 karakter' : null,
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await auth.loginEmail(
                                    email: emailC.text.trim(),
                                    password: passC.text.trim(),
                                  );
                                } catch (e) {
                                  _error(context, e.toString());
                                }
                              }
                            },
                      child: auth.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('LOGIN'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _error(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
