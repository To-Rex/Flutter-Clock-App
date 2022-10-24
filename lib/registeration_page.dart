
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 221, 221),
                  border: Border.all(
                      color: const Color.fromARGB(255, 221, 221, 221), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  cursorColor: Colors.deepPurpleAccent,
                  controller: _emailController,
                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: 'Email',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 221, 221),
                  border: Border.all(
                      color: const Color.fromARGB(255, 221, 221, 221), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  cursorColor: Colors.deepPurpleAccent,
                  controller: _passwordController,
                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: 'Password',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 221, 221),
                  border: Border.all(
                      color: const Color.fromARGB(255, 221, 221, 221), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  cursorColor: Colors.deepPurpleAccent,
                  controller: _confirmPasswordController,
                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: 'Confirm Password',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.055,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kirish',
                  ),
                ),
              ),
            ),

            //bottom sign up text password
            const Expanded(child: Text('')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //start actvity registration page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ]
        )
      ),
    );
  }
}
