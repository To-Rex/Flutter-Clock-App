import 'dart:convert';

import 'package:clock_mobile/settings_page.dart';
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
  var token = "";
  var times = [];
  var coments = [];
  var switchs = [];
  var companets = [];
  bool _isLoading = false;

  Future<void> getTemes() async {
    _isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    final response = await http.get(
      Uri.parse("https://calcappworks.herokuapp.com/gettimes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var data = jsonDecode(response.body);
    times = data['times'];
    coments = data['coments'];
    switchs = data['switch'];
    companets = data['companets'];
    _isLoading = false;
    setState(() {});
  }

  //add time function
  Future<void> addTime() async {
    _isLoading = true;
    var clock = _timesControlle.text.substring(11, 16);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/addtime"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'times': clock,
        'coments': _comentControle.text,
        'switch': _switchControle.text,
      }),
    );
    _isLoading = false;
    getTemes();
  }

  //delete time function
  Future<void> deleteTime(int index) async {
    _isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/deletetime?index=$index"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _isLoading = false;
    times.clear();
    coments.clear();
    switchs.clear();
    getTemes();
  }

  //update time function
  Future<void> updateTime(int index) async {
    _isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    await http.post(
      Uri.parse("https://calcappworks.herokuapp.com/updatetime?index=$index"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'times': _timesControlle.text.substring(11, 16),
        'coments': _comentControle.text,
        'switch': _switchControle.text,
      }),
    );
    _isLoading = false;
    times.clear();
    coments.clear();
    switchs.clear();
    getTemes();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Yangi Vaqt Qo`shish"),
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.2,
                  child: TimePickerSpinner(
                    is24HourMode: true,
                    alignment: Alignment.center,
                    isShowSeconds: false,
                    time: DateTime.now(),
                    normalTextStyle:
                    const TextStyle(fontSize: 20, color: Colors.black12),
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
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      controller: _comentControle,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding:
                        EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Izoh',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.02,
                ),
                if(_isLoading)
                  const CircularProgressIndicator()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(33, 158, 188, 10),
                        border: Border.all(width: 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _isLoading ? null : addTime();
                          _switchControle.text = "true";
                          setState(() {});
                          addTime();
                          _isLoading = true;
                          //dialogdan chiqish
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Saqlash",
                          style: TextStyle(
                            color: Color.fromARGB(255, 2, 48, 71),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01,
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //update time dialog
  void _updateDialog(int index) {
    _timesControlle.text = times[index];
    _comentControle.text = coments[index];
    _switchControle.text = switchs[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Yangi Vaqt Qo`shish"),
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: TimePickerSpinner(
                    is24HourMode: true,
                    alignment: Alignment.center,
                    isShowSeconds: false,
                    time: DateTime.now(),
                    normalTextStyle:
                    const TextStyle(fontSize: 20, color: Colors.black12),
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
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      controller: _comentControle,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration:  const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Izoh',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                if(_isLoading)
                  const CircularProgressIndicator()
                 else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(33, 158, 188, 10),
                      border: Border.all(width: 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _isLoading ? null : updateTime(index);
                        //_switchControle.text = "false";
                        setState(() {});
                        updateTime(index);
                        //dialogdan chiqish
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Saqlash",
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 48, 71),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("O`chirish"),
          content: const Text("O`chirishni istaysizmi?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _isLoading ? null : deleteTime(index);
                _switchControle.text = "false";
                setState(() {});
                deleteTime(index);
                //dialogdan chiqish
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ha",
                style: TextStyle(
                  color: Color.fromARGB(255, 2, 48, 71),
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //dialogdan chiqish
                Navigator.of(context).pop();
              },
              child: const Text(
                "Yo`q",
                style: TextStyle(
                  color: Color.fromARGB(255, 2, 48, 71),
                  fontSize: 20,
                ),
              ),
            ),
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
                              onTap: () {
                                _updateDialog(index);
                              },
                              onLongPress: () {
                                _deleteDialog(index);
                              },
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
                                  value: switchs[index] == "true" ? true : false,
                                  borderRadius: 8.0,
                                  padding: 2.4,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white,
                                  toggleColor:
                                      const Color.fromRGBO(33, 158, 188, 10),
                                  onToggle: (val) {
                                    switchs[index] = val.toString();
                                    _switchControle.text = val.toString();
                                    print(_switchControle.text);
                                    updateTime(index);
                                    setState(() {
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  children: [
                    const Expanded(child: Text("")),
                    FloatingActionButton(
                      splashColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
                      onPressed: () {
                        times.clear();
                        coments.clear();
                        switchs.clear();
                        getTemes();
                        setState(() {});
                      },
                      child: const Icon(Icons.refresh),
                    ),
                    const Expanded(child: Text("")),

                  ],
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
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator(color: Colors.white,)
            else
            const Icon(
              Icons.add,
              size: 35,
              color: Color.fromARGB(255, 2, 48, 71),
            ),
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
