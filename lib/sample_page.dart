import 'dart:convert';

import 'package:clock_mobile/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late final _timesControlle = TextEditingController();
  late final _comentControle = TextEditingController();
  late final _switchControle = TextEditingController();
  bool _validateEmail = false;
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
    final response = await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/addtime"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'times': "15:00",
        'coments': "coment",
        'switch': "true",
      }),
    );
    print(response.body);
    getTemes();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add time"),
          content: const Text("Do you want to add time?"),
          actions: <Widget>[
            Column(
              children: [
                TimePickerSpinner(
                  is24HourMode: true,
                  alignment: Alignment.center,
                  isShowSeconds: false,
                  time: DateTime.now(),
                  normalTextStyle: const TextStyle(
                      fontSize: 20, color: Colors.black12),
                  highlightedTextStyle: const TextStyle(
                      fontSize: 28, color: Color.fromRGBO(33, 158, 188, 10)),
                  spacing: 30,
                  itemHeight: 50,
                  isForce2Digits: false,
                  minutesInterval: 1,
                  onTimeChange: (time) {
                    setState(() {
                      _timesControlle.text = time.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _comentControle,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Coment',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    addTime();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add"),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getTemes();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timesControlle.dispose();
    _comentControle.dispose();
    _switchControle.dispose();

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
                //refresh button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(33, 158, 188, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        times.clear();
                        coments.clear();
                        switchs.clear();
                        getTemes();
                        setState(() {

                        });
                      },
                      child: const Text(
                        'Refresh',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
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
          _showDialog();
         // addTime();
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
