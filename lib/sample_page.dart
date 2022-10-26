import 'package:clock_mobile/settings_page.dart';
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
                  color: const Color.fromRGBO(33, 158, 188, 10),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingsPage();
                    }));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            
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
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('data'),
                      subtitle: const Text('data'),
                      leading: const Icon(Icons.settings),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
        child: const Icon(
          Icons.add,
          size: 35,
          color: Color.fromARGB(255, 2, 48, 71),
        ),
      ),
    );
  }
}
