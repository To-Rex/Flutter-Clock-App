import 'dart:async';
import 'dart:convert';

import 'package:clock_mobile/registeration_page.dart';
import 'package:clock_mobile/sample_page.dart';
import 'package:clock_mobile/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();
  bool _validateEmail = false;
  bool _validatepassword = false;
  bool _check = false;
  var verifyCode = "";

  @override
  void initState() {
    super.initState();
  }
  Future<void> resendCode() async {
    final response = await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/resendverefy"),
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
      }),
    );
    if (response.statusCode == 200) {
      verifyCode = json.decoder.convert(response.body)['verefyCode'];
      print(verifyCode);
      VerifyPage(_emailController.text, verifyCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('pochtangiz tekshirib ko\'ring'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          //time out 2 sec
          duration: Duration(milliseconds: 700),
          //position of snackbar
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      //snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Kodni yuborishda xatolik'),
        ),
      );
    }
  }

  Future<void> _login() async {
    _check = true;
    final response = await http.post(
      Uri.parse(
          "https://calcappworks.herokuapp.com/login"),
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      var token = json.decoder.convert(response.body)['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
            return const SamplePage();
          }));
    } else {
      setState(() {});
      if(json.decoder.convert(response.body)['error']=='email is not verified') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('pochtangiz tasdiqlanmagan'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            //time out 2 sec
            duration: Duration(milliseconds: 700),
            //position of snackbar
            behavior: SnackBarBehavior.floating,
          ),
        );
        _login();
        _check = false;
      }
      if(json.decoder.convert(response.body)['error']=='password is incorrect') {
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('parol xato'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            //time out 2 sec
            duration: Duration(milliseconds: 700),
            //position of snackbar
            behavior: SnackBarBehavior.floating,
          ),
        );
        _check = false;
      }
      if(json.decoder.convert(response.body)['error']=='user is blocked') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Akkauntingiz bloklangan Managerga murojaat qiling'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            //time out 2 sec
            duration: Duration(milliseconds: 1900),
            //position of snackbar
            behavior: SnackBarBehavior.floating,
          ),
        );
        _check = false;
      }

      if(json.decoder.convert(response.body)['error']=='email is incorrect') {
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('pochta topilmadi'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            //time out 2 sec
            duration: Duration(milliseconds: 1700),
            //position of snackbar
            behavior: SnackBarBehavior.floating,
          ),
        );
        _check = false;
      }
      print(response.body);
    }
  }

  Future<void> valFun() async {
    //time out 2 sec _validateEmail = false;
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _validateEmail = false;
        _validatepassword = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
          elevation: 3,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //email field
            const Expanded(child: Text('')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 221, 221),
                  border: Border.all(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  cursorColor: Colors.deepPurpleAccent,
                  controller: _emailController,
                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: 'Pochta',
                    errorText: _validateEmail ? 'Pochta kiriting' : null,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //password field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 221, 221),
                  border: Border.all(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  cursorColor: Colors.deepPurpleAccent,
                  controller: _passwordController,
                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: 'Parol',
                    errorText: _validatepassword ? 'Parol kiriting' : null,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            //forgot password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Parolingizni unitdingizmi?',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //login button
            if(!_check)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.055,
                child: ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      setState(() {
                        _validateEmail = true;
                      });
                    } else {
                      setState(() {
                        _validateEmail = false;
                      });
                    }
                    if (_passwordController.text.isEmpty) {
                      setState(() {
                        _validatepassword = true;
                      });
                    } else {
                      setState(() {
                        _validatepassword = false;
                      });
                    }
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty&&
                        _emailController.text.length>5&&
                        _passwordController.text.length>4) {
                      _login();
                    }else{
                      valFun();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nimadur xato Ketdi'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          //time out 2 sec
                          duration: Duration(milliseconds: 700),
                          //position of snackbar
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kirish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            if(_check)
              const CircularProgressIndicator(),
            //bottom sign up text password
            const Expanded(child: Text('')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hisobingiz Yo\`qmi?',
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
                      'Ro\`yhatdan o`tish',
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
          ],
        ),
      ),
    );
  }
}
