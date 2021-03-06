import 'dart:io';
import 'package:chuck_norris_joke_app/first_screen.dart';
import 'package:chuck_norris_joke_app/language_text.dart';
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
      if (language == 'ru') {
        query = await translateText(query, language, 'en');
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
      child: Column(children: [
        TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: language == 'en'
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
                return Text(language == 'en'
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
                          color: Colors.yellow[100],
                          elevation: 5,
                          key: UniqueKey(),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            subtitle: LanguageText(
                              text: searchTerms[index],
                              size: 15,
                              color: Colors.black,
                            ),
                            leading: const Icon(
                              Icons.list,
                              size: 25,
                              color: Colors.black,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                favoriteJokes.contains(searchTerms[index])
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 25,
                                color: Colors.black,
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
      ]),
    );
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var t in searchTerms) {
//       if (t.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(t);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return Card(
//           color: Colors.yellow[100],
//           elevation: 7,
//           key: UniqueKey(),
//           //shadowColor: Colors.lightBlueAccent,
//           margin: const EdgeInsets.symmetric(vertical: 6),
//           child: ListTile(
//             subtitle: Text(
//               result,
//               style: const TextStyle(
//                 fontSize: 15,
//                 color: Colors.black,
//                 fontFamily: "KanitItalic",
//               ),
//             ),
//             leading: const Icon(
//               Icons.list,
//               size: 15,
//               color: Colors.black,
//             ),
//             trailing: IconButton(
//               icon: Icon(
//                 favoriteJokes.contains(result)
//                     ? Icons.favorite
//                     : Icons.favorite_outline,
//               ),
//               onPressed: () {
//                 if (favoriteJokes.contains(result)) {
//                   removeJoke(result);
//                 } else {
//                   likedJoke(result);
//                 }
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var t in searchTerms) {
//       if (t.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(t);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
