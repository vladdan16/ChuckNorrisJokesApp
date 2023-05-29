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

Language language = Language.english;

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
        title: Text(
          language == Language.english
              ? titles[pageIndex]
              : russianTitles[pageIndex],
          style: TextStyle(
            fontSize: 30,
            fontFamily: language == Language.russian ? 'Comfortaa' : 'Kanit',
          ),
        ),
        centerTitle: true,
      ),
      body: pages[pageIndex],
      floatingActionButton: pageIndex == 0
          ? FloatingActionButton(
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        selectedIndex: pageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
