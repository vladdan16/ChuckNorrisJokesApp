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

  String _joke = "Press button to see joke";

  void getNewJoke() async {
    var url = Uri.parse('https://api.chucknorris.io/jokes/random');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (kDebugMode) {
        print(jsonResponse['value']);
      }
      _joke = jsonResponse['value'];
    }
  }

  @override
  void initState() {
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
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/newChuckNorris.png'),
            const SizedBox(
              height: 100,
            ),
            Text(
              _joke,
              style: const TextStyle(
                fontSize: 30,
              ),

            ),
            IconButton(
              icon: const Icon(
                Icons.thumb_up,
                color: Colors.red,
              ),
              iconSize: 40,
              onPressed: () {
                getNewJoke();
                setState(() => {});
                if (kDebugMode) {
                  print('Thumb up button has been pressed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

