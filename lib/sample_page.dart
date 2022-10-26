import 'dart:convert';

import 'package:clock_mobile/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_switch/flutter_switch.dart';

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

  //add time function
  Future<void> addTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    print(token);
    final response = await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/addtime"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'times': "00:00",
        'coments': "coment",
        'switch': "false",
      }),
    );
    print(response.body);
    getTemes();
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
      body: ListView(
        children: [
          Center(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      border: Border.all(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          width: 10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: times.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(times[index],
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 2, 48, 71),
                                      textBaseline: TextBaseline.ideographic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              subtitle: Text(coments[index],
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 2, 48, 71),
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 15)),
                              trailing: SizedBox(
                                width: 100,
                                child: FlutterSwitch(
                                  width: 50.0,
                                  height: 25.0,
                                  valueFontSize: 20.0,
                                  toggleSize: 25.0,
                                  value:
                                      switchs[index] == "true" ? true : false,
                                  borderRadius: 8.0,
                                  padding: 2.4,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white,
                                  toggleColor:
                                      const Color.fromRGBO(33, 158, 188, 10),
                                  onToggle: (val) {
                                    setState(() {
                                      switchs[index] = val.toString();
                                    });
                                  },
                                  //togle radius 8 and color 0xff1f1f1f and text color 0xff1f1f1f
                                ),
                              ),
                            ),
                            const Divider(
                              height: 4,
                              thickness: 4,
                              color: Colors.white,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          addTime();
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
