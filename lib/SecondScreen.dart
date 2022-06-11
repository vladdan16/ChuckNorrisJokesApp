import 'package:flutter/material.dart';

import 'FirstScreen.dart';

Set<String> favoriteJokes = {};

void removeJoke(String joke) {
  favoriteJokes.remove(joke);
  writeJSON();
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
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Colors.yellow[100],
                elevation: 7,
                key: UniqueKey(),
                //shadowColor: Colors.lightBlueAccent,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
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
                      removeJoke(favoriteJokes.elementAt(index));
                      setState(() {});
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}

