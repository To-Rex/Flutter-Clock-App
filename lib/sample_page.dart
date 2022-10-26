import 'dart:convert';

import 'package:clock_mobile/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  var token = "";
  var times = [];
  var coments = [];
  var switchs = [];
  var companets = [];


  Future<void> getTemes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    final response = await http.get(
      Uri.parse("https://calcappworks.herokuapp.com/gettimes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    var data = jsonDecode(response.body);
    times = data['times'];
    coments = data['coments'];
    switchs = data['switch'];
    companets = data['companets'];
    print(times);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTemes();
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
            //times list
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: times.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(times[index]),
                      subtitle: Text(coments[index]),
                      trailing: Switch(
                        value: Text(switchs[index]) == "true", onChanged: (bool value) {  },
                      ),
                    ),
                  );
                },
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
