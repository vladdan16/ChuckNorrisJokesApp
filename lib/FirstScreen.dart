import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyClass extends StatelessWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChuckNorrisJokesApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Tinder with Chuck'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _joke = "Press the button to see joke";

  bool ifStart = true;

  void getNewJoke() async {
    var url = Uri.parse('https://api.chucknorris.io/jokes/random');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (kDebugMode) {
        print(jsonResponse['value']);
      }
      _joke = jsonResponse['value'];
    } else {
      throw Exception('Error was handled!');
    }
  }

  @override
  void initState() {
    getNewJoke();
    super.initState();
    if (kDebugMode) {
      print("Init State");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Build");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: <Widget>[
              Image.asset('assets/images/newChuckNorris.png'),
              const SizedBox(
                height: 70,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(
                    width: 3,
                    color: Colors.cyan,
                  ),
                ),
                child: Text(
                  _joke,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: IconButton(
                  icon: Icon(
                    ifStart ? Icons.play_arrow : Icons.thumb_up,
                    color: Colors.red,
                  ),
                  iconSize: 60,
                  onPressed: () {
                    setState(() => {});
                    getNewJoke();
                    ifStart = false;
                    if (kDebugMode) {
                      print('Thumb up button has been pressed');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
