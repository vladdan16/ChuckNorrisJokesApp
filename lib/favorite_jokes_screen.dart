import 'package:flutter/material.dart';

import 'first_screen.dart';
import 'language_text.dart';

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
                elevation: 7,
                key: UniqueKey(),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  subtitle: LanguageText(
                    text: favoriteJokes.elementAt(index),
                    size: 15,
                  ),
                  leading: const Icon(
                    Icons.list,
                    size: 15,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
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
