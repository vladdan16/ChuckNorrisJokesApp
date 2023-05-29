import 'dart:io';
import 'dart:math';
import 'package:chuck_norris_joke_app/settings_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'filter_screen.dart';
import 'first_screen.dart';
import 'favorite_jokes_screen.dart';
import 'language_text.dart';

String _joke =
    "Swipe this text or press the button to see joke\nNote: If you like joke, swipe to right, else swipe to left";

const String _startMessage =
    "Swipe this text or press the button to see joke\nNote: If you like joke, swipe to right, else swipe to left";

bool getJoke = false;

int pageIndex = 0;

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

void likedJoke(String joke) {
  favoriteJokes.add(joke);
  writeJSON();
}

//Function to get new joke from api
Future<void> getNewJoke() async {
  if (getJoke) {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (chosenCategories.isEmpty ||
            chosenCategories.length == categories.length) {
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
        } else {
          int index = random.nextInt(chosenCategories.length);
          var url = Uri.parse(
              'https://api.chucknorris.io/jokes/random?category=${chosenCategories.elementAt(index)}');
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
      } else {
        _joke = "Check your internet connection";
      }
    } on SocketException catch (_) {
      _joke = "Check your internet connection";
    }
    getJoke = false;
  }
}

class JokeScreen extends StatefulWidget {
  const JokeScreen({Key? key}) : super(key: key);

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Center(
          child: ListView(
            children: <Widget>[
              //Widget for showing an image with Chuck Norris
              SizedBox(
                height: 290,
                child: Image.asset(images[imageIndex]),
              ),
              const SizedBox(
                height: 20,
              ),
              //Dismissible widget for text of joke, to perform swipe
              Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    if (_joke != "Check your internet connection" && !ifStart) {
                      //favoriteJokes.add(_joke);
                      likedJoke(_joke);
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
                  //alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: FutureBuilder(
                    key: UniqueKey(),
                    builder: (context, snapshot) {
                      if (kDebugMode) {
                        print(snapshot.connectionState);
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                          return LanguageText(
                            text: ifStart ? _startMessage : _joke,
                            size: language == Language.english ? 25 : 22,
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
                                if (_joke != "Check your internet connection" &&
                                    !ifStart) {
                                  //favoriteJokes.add(_joke);
                                  likedJoke(_joke);
                                }
                                if (_joke != "Check your internet connection") {
                                  changeImage();
                                }
                                getJoke = true;
                                setState(() {});
                                ifStart = false;
                                if (kDebugMode) {
                                  print('Thumb up button has been pressed');
                                  print('You liked: $_joke');
                                }
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.thumb_down,
                                color: Colors.redAccent,
                              ),
                              iconSize: 60,
                              onPressed: () {
                                getJoke = true;
                                changeImage();
                                setState(() {});
                                ifStart = false;
                                if (kDebugMode) {
                                  print('Thumb down button has been pressed');
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
    );
  }
}
