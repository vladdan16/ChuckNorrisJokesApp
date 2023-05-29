import 'dart:io';
import 'package:chuck_norris_joke_app/first_screen.dart';
import 'package:chuck_norris_joke_app/language_text.dart';
import 'package:chuck_norris_joke_app/settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'joke_screen.dart';
import 'favorite_jokes_screen.dart';

List<String> searchTerms = [];

Future<void> getJokesFromQuery(String query) async {
  searchTerms = [];
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      if (language == Language.russian) {
        query = await translateText(query, language, Language.english);
      }
      var url =
          Uri.parse('https://api.chucknorris.io/jokes/search?query=$query');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        int total = jsonResponse['total'];
        var listOfJokes = jsonResponse['result'] as List<dynamic>;
        for (int i = 0; i < total; i++) {
          var map = listOfJokes[i] as Map<String, dynamic>;
          searchTerms.add(map['value']);
        }
      }
    } else {
      searchTerms = ['Check your internet connection'];
    }
  } on SocketException catch (_) {
    searchTerms = ['Check your internet connection'];
  }
}

String myQuery = "";

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: language == Language.english
                    ? 'Enter some text to search joke'
                    : 'Введите текст для поиска',
              ),
              onChanged: (text) {
                if (text != "") {
                  myQuery = text;
                  getJokesFromQuery(text);
                  setState(() {});
                }
              },
            ),
          ),
          FutureBuilder(
            future: getJokesFromQuery(myQuery),
            key: UniqueKey(),
            builder: (context, snapshot) {
              if (kDebugMode) {
                print(
                    'List of jokes to search. Connection state: ${snapshot.connectionState}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (kDebugMode) {
                    print(snapshot.error);
                  }
                  return Text(language == Language.english
                      ? 'Check your internet connection'
                      : 'Проверьте ваше нитернет соединение');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: searchTerms.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: 5,
                            key: UniqueKey(),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              subtitle: LanguageText(
                                text: searchTerms[index],
                                size: 15,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                              leading: const Icon(
                                Icons.list,
                                size: 25,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  favoriteJokes.contains(searchTerms[index])
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  size: 25,
                                ),
                                onPressed: () {
                                  if (favoriteJokes
                                      .contains(searchTerms[index])) {
                                    removeJoke(searchTerms[index]);
                                  } else {
                                    if (searchTerms[index] !=
                                        'Check your internet connection') {
                                      likedJoke(searchTerms[index]);
                                    }
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              } else {
                return const Text("Error");
              }
            },
          ),
        ],
      ),
    );
  }
}
