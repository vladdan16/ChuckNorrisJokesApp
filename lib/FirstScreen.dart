import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Set<String> favoriteJokes = {};

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

  List<String> titles = [
    'Tinder with Chuck',
    'Your favorite jokes',
  ];

  bool getJoke = false;

  int pageIndex = 0;

  final pages = [
    null,
    FavoriteJokes(
      title: 'title',
    ),
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
  Future<void> getNewJoke() async {
    if (getJoke) {
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
      getJoke = false;
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
        backgroundColor: Colors.purple[400],
        title: Text(
          titles[pageIndex],
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
                    color: Colors.white,
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
                          if (direction == DismissDirection.startToEnd) {
                            if (_joke != "Check your internet connection") {
                              favoriteJokes.add(_joke);
                            }
                          }
                          if (_joke != "Check your internet connection") {
                            changeImage();
                          }
                          getJoke = true;
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
                          child: FutureBuilder(
                            key: UniqueKey(),
                            builder: (context, snapshot) {
                              if (kDebugMode) {
                                print(snapshot.connectionState);
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return const Text(
                                    "Check your internet connection",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: "KanitItalic",
                                    ),
                                  );
                                } else {
                                  return Text(
                                    _joke,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: "KanitItalic",
                                    ),
                                  );
                                }
                              }
                              return Text(
                                "State: ${snapshot.connectionState}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontFamily: "KanitItalic",
                                ),
                              );
                            },
                            future: getNewJoke(),
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
                                        if (_joke != "Check your internet connection") {
                                          favoriteJokes.add(_joke);
                                          changeImage();
                                        }
                                        getJoke = true;
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
                                        getJoke = true;
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
                                  getJoke = true;
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
        height: 50,
        decoration: BoxDecoration(
          color: Colors.purple[400],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                if (pageIndex != 0) {
                  setState(() {
                    pageIndex = 0;
                  });
                }
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
                if (pageIndex != 1) {
                  setState(() {
                    pageIndex = 1;
                  });
                }
              },
              icon: Icon(
                pageIndex == 1 ? Icons.favorite : Icons.favorite_outline,
                color: Colors.white,
                size: 35,
              ),
            ),
            // IconButton(
            //   enableFeedback: false,
            //   onPressed: () {
            //     setState(() {
            //       pageIndex = 2;
            //     });
            //   },
            //   icon: Icon(
            //     pageIndex == 2 ? Icons.widgets_rounded : Icons.widgets_outlined,
            //     color: Colors.white,
            //     size: 35,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class FavoriteJokes extends StatefulWidget {
  const FavoriteJokes({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FavoriteJokes> createState() => _FavoriteJokesState();
}

class _FavoriteJokesState extends State<FavoriteJokes> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
          itemCount: favoriteJokes.length,
          //physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Colors.yellow[100],
                elevation: 10,
                key: UniqueKey(),
                //shadowColor: Colors.lightBlueAccent,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  // title: Text(
                  //   "Joke ${index + 1}",
                  //   style: const TextStyle(
                  //     fontSize: 20,
                  //     fontFamily: "KanitItalic"
                  //   ),
                  // ),
                  subtitle: Text(
                    favoriteJokes.elementAt(index),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "KanitItalic",
                    ),
                  ),
                  leading: const Icon(
                    Icons.list,
                    size: 15,
                    color: Colors.black,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      favoriteJokes.remove(favoriteJokes.elementAt(index));
                      setState(() {});
                    },
                  ),
                ),

              ),
            );
            // return ListTile(
            //   leading: const Icon(Icons.list),
            //   title: Text(
            //     favoriteJokes[index],
            //     style: const TextStyle(
            //       fontSize: 15,
            //       fontFamily: "KanitItalic",
            //     ),
            //   ),
            // );
          }),
    );
  }
}
