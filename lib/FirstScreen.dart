import 'dart:convert' as convert;
import 'dart:io';
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
        //primarySwatch: Colors.blue,
        fontFamily: 'Kanit',
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
  String _joke = "Swipe this text or press the button to see joke";

  bool ifStart = true;

  void getNewJoke() async {
    try {
      final result =
          await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var url = Uri.parse('https://api.chucknorris.io/jokes/random');
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var jsonResponse =
              convert.jsonDecode(response.body) as Map<String, dynamic>;
          if (kDebugMode) {
            print(jsonResponse['value']);
          }
          _joke = jsonResponse['value'];
        }
      }
    } on SocketException catch (_) {
      _joke = "Check your internet connection";
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
        backgroundColor: Colors.purple[400],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(247, 248, 243, 1.0),
            ),
          ),
          Center(
            child: ListView(
              children: <Widget>[
                Image.asset('assets/images/ChuckNorrisFace.jpg'),
                const SizedBox(
                  height: 20,
                ),
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    getNewJoke();
                    ifStart = false;
                    setState(() {});
                  },
                  background: Container(
                    alignment: Alignment.center,
                    color: Colors.blue[300],
                    child: const Padding(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Icon(
                        Icons.favorite,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                    ),
                    child: Text(
                      _joke,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: "KanitItalic",
                      ),
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
        ]),
      ),
    );
  }
}
