
import 'dart:async';

import 'package:flutter/material.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late final _codeController = TextEditingController();

  //counter down timer for resend code button in seconds (60 seconds)
  late  int _counter = 60;

  //timer for counter down
  late final _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      if (_counter > 0) {
        _counter--;
      } else {
        timer.cancel();
      }
    });
  });

  //resend code button
  Widget _resendCodeButton() {
    return TextButton(
      onPressed: _counter > 0
          ? null
          : () {
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

  @override
  void initState() {
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
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: 'Tasdiqlash elektron pochta kodi',
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