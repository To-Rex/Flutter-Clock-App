
import 'package:flutter/material.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
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
          children: [
            //settings icon top right icon size 60 and color 0xff1f1f1f
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  iconSize: 35,
                  color: const Color(0xff1f1f1f),
                  onPressed: () {
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}