import 'dart:io';
import 'package:chuck_norris_joke_app/joke_screen.dart';
import 'package:chuck_norris_joke_app/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:path_provider/path_provider.dart';

import 'favorite_jokes_screen.dart';
import 'filter_screen.dart';
import 'settings_screen.dart';

String language = 'en';

Future<String?> get _localPath async {
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  return directory?.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/favoriteJokes.json');
}

Future<File> writeJSON() async {
  final file = await _localFile;

  List<Map> jsonList = [];

  for (int i = 0; i < favoriteJokes.length; i++) {
    jsonList.add({"joke": favoriteJokes.elementAt(i)});
  }
  var jsonText = convert.jsonEncode(jsonList);

  // Write the file
  return file.writeAsString(jsonText);
}

Future<void> readJSON() async {
  try {
    final file = await _localFile;
    var jsonString = file.readAsStringSync();
    var jsonResponse = convert.jsonDecode(jsonString) as List;
    for (int i = 0; i < jsonResponse.length; i++) {
      var jokeMap = jsonResponse[i] as Map;
      favoriteJokes.add(jokeMap['joke']);
    }
  } catch (e) {
    throw Exception("Error when reading file: $e");
  }
}

class MyClass extends StatelessWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChuckNorrisJokesApp',
      theme: ThemeData(
        useMaterial3: true,
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

  final pages = [
    const JokeScreen(),
    const FavoriteJokes(
      title: 'title',
    ),
    const SearchScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Tinder with Chuck',
    'Favorite jokes',
    'Search for jokes',
    'Settings',
  ];

  List<String> russianTitles = [
    "Тиндер с Чаком",
    "Любимые шутки",
    "Поиск шуток",
    "Настройки",
  ];

  @override
  void initState() {
    readJSON();
    super.initState();
    //askStoragePermission();
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
            language == 'en'
                ? titles[pageIndex]
                : russianTitles[pageIndex],
            style: TextStyle(
              fontSize: 30,
              fontFamily: language == 'ru' ? 'Comfortaa' : 'Kanit',
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: pages[pageIndex],
      floatingActionButton: pageIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.purple[400],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JokesFilter(),
                  ),
                );
              },
              child: const Icon(
                Icons.tune,
                size: 30,
              ),
            )
          : null,
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.purple[400],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                if (pageIndex != 0) {
                  setState(() {
                    pageIndex = 0;
                  });
                }
              },
              icon: Icon(
                pageIndex == 0 ? Icons.home : Icons.home_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
            IconButton(
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
            IconButton(
              onPressed: () {
                if (pageIndex != 2) {
                  setState(() {
                    pageIndex = 2;
                  });
                }
              },
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 35,
              ),
            ),
            IconButton(
              icon: Icon(
                pageIndex == 3 ? Icons.settings : Icons.settings_outlined,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                if (pageIndex != 3) {
                  setState(() {
                    pageIndex = 3;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
