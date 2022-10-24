
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {

  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();
  late final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Page'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text == _confirmPasswordController.text) {
                  print('success');
                } else {
                  print('error');
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
