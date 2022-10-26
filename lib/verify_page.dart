import 'dart:async';
import 'dart:convert';
import 'package:clock_mobile/sample_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPage extends StatefulWidget {
  var email;
  var code;
  bool _validateCode = false;

  VerifyPage(this.email, this.code, {super.key});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late final _codeController = TextEditingController();
  late int _counter = 60;
  var verifyCode = "";

  late final _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      if (_counter > 0) {
        _counter--;
      } else {
        timer.cancel();
      }
    });
  });

  Widget _resendCodeButton() {
    return TextButton(
      onPressed: _counter > 0
          ? null
          : () {
              resendCode();
              setState(() {
                _counter = 60;
                _timer;
              });
            },
      child: Text(
        _counter > 0 ? '$_counter soniya' : 'Kod yetib kelmadimi?',
        style: const TextStyle(
          color: Color.fromARGB(255, 33, 158, 188),
        ),
      ),
    );
  }

  Future<void> resendCode() async {
    print(widget.email);
    print(widget.code);
    final response = await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/resendverefy"),
      body: jsonEncode(<String, String>{
        'email': widget.email,
      }),
    );
    if (response.statusCode == 200) {
      verifyCode = json.decoder.convert(response.body)['verefyCode'];
      print(verifyCode);
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

  Future<void> verify() async {
    final response = await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/verefyuser"),
      body: jsonEncode(<String, String>{
        'email': widget.email,
        'verefyCode': _codeController.text,
      }),
    );
    if (response.statusCode == 200) {
      var token = json.decoder.convert(response.body)['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }else{
      setState(() {
        widget._validateCode = true;
      });
    }
  }

  @override
  void initState() {
    print(widget.email);
    print(widget.code);
    verifyCode = widget.code;
    super.initState();
    _timer;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _codeController.dispose();
    _timer.cancel();
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
                  controller: _codeController,
                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: 'Tasdiqlash elektron pochta kodi',
                    errorText: widget._validateCode
                        ? 'Kodni kiriting'
                        : null, // if _validateCode is true, errorText will be shown
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _resendCodeButton(),
                ],
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
                  onPressed: () {
                    setState(() {
                      _codeController.text.isEmpty
                          ? widget._validateCode = true
                          : widget._validateCode = false;
                    });
                    if (_codeController.text.length > 5) {
                      if (_codeController.text == verifyCode.toString()) {
                        verify();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Tasdiqlash kod to\'g\'ri'),
                          ),
                        );
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const SamplePage();
                        }));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Kod noto\'g\'ri'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Tasdiqlash',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
