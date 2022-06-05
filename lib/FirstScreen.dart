import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyClass extends StatelessWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChuckNorrisJokesApp',
      theme: ThemeData(
        fontFamily: 'Kanit',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
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
  //Text that will be shown to user
  String _joke = "Swipe this text or press the button to see joke";
  String _previousJoke = "";

  int pageIndex = 0;

  final pages = [
    const Page2(),
    const Page3(),
    const Page4(),
  ];

  int imageIndex = 0;

  //List of images
  List<String> images = [
    'assets/images/ChuckNorris6.png',
    'assets/images/ChuckNorris7.png',
    'assets/images/ChuckNorris8.png',
    'assets/images/ChuckNorris11.png',
    'assets/images/ChuckNorris12.png',
    'assets/images/ChuckNorris26.png',
    'assets/images/ChuckNorris29.png',
    'assets/images/ChuckNorris31.png',
  ];

  void changeImage() {
    imageIndex = random.nextInt(images.length);
  }

  //Random is needed for choosing a random image for showing
  Random random = Random();

  //Flag to identify if the application is on start state
  bool ifStart = true;

  //Function to get new joke from api
  void getNewJoke() async {
    _previousJoke = _joke;
    try {
      final result = await InternetAddress.lookup('example.com');
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
      body: pageIndex == 0
          ? SafeArea(
              child: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(247, 248, 243, 1.0),
                  ),
                ),
                Center(
                  child: ListView(
                    children: <Widget>[
                      //Widget for showing an image with Chuck Norris
                      SizedBox(
                          height: 290, child: Image.asset(images[imageIndex])),
                      const SizedBox(
                        height: 20,
                      ),
                      //Dismissible widget for text of joke, to perform swipe
                      Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          getNewJoke();
                          changeImage();
                          ifStart = false;
                          setState(() {});
                        },
                        background: Container(
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: Icon(
                              Icons.favorite,
                              size: 70,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: Icon(
                              Icons.heart_broken,
                              size: 70,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                      //Widget for button
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: !ifStart
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: Colors.green[400],
                                      ),
                                      iconSize: 60,
                                      onPressed: () {
                                        getNewJoke();
                                        changeImage();
                                        setState(() {});
                                        ifStart = false;
                                        if (kDebugMode) {
                                          print(
                                              'Thumb up button has been pressed');
                                          print('You liked: $_joke');
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.thumb_down,
                                        color: Colors.green[400],
                                      ),
                                      iconSize: 60,
                                      onPressed: () {
                                        getNewJoke();
                                        changeImage();
                                        setState(() {});
                                        ifStart = false;
                                        if (kDebugMode) {
                                          print(
                                              'Thumb down button has been pressed');
                                        }
                                      },
                                    )
                                  ])
                            : IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.green[400],
                                ),
                                iconSize: 80,
                                onPressed: () {
                                  getNewJoke();
                                  changeImage();
                                  setState(() {});
                                  ifStart = false;
                                  if (kDebugMode) {
                                    print('Play button has been pressed');
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          : pages[pageIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: Icon(
                pageIndex == 0 ? Icons.home_filled : Icons.home_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: Icon(
                pageIndex == 1
                    ? Icons.work_rounded
                    : Icons.work_outline_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: Icon(
                pageIndex == 2 ? Icons.widgets_rounded : Icons.widgets_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 2",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 3",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 4",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
