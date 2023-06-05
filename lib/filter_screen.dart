import 'package:chuck_norris_joke_app/first_screen.dart';
import 'package:chuck_norris_joke_app/settings_screen.dart';
import 'package:flutter/material.dart';

Set<String> chosenCategories = {};

List<bool> chooseCategories = List<bool>.filled(categories.length, false);

List<String> categories = [
  "animal",
  "career",
  "celebrity",
  "dev",
  "explicit",
  "fashion",
  "food",
  "history",
  "money",
  "movie",
  "music",
  "political",
  "religion",
  "science",
  "sport",
  "travel",
];

List<String> russianCategories = [
  "животные",
  "карьера",
  "знаменитости",
  "разработка",
  "откровенное",
  "мода",
  "еда",
  "история",
  "деньги",
  "фильмы",
  "музыка",
  "политика",
  "религия",
  "наука",
  "спорт",
  "путешествия",
];

class JokesFilter extends StatefulWidget {
  const JokesFilter({Key? key}) : super(key: key);

  @override
  State<JokesFilter> createState() => _JokesFilterState();
}

class _JokesFilterState extends State<JokesFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          language == Language.english
              ? 'Choose categories'
              : 'Выбор категорий',
          style: TextStyle(
            fontSize: language == Language.english ? 30 : 25,
            fontFamily: language == Language.english ? 'Kanit' : 'Comfortaa',
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (chooseCategories[index]) {
                  chosenCategories.remove(chooseCategories.elementAt(index));
                  chooseCategories[index] = false;
                } else {
                  chooseCategories[index] = true;
                  chosenCategories.add(categories[index]);
                }
                setState(() {});
              },
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 2),
                child: Card(
                  key: UniqueKey(),
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Checkbox(
                        value: chooseCategories[index],
                        onChanged: null,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        language == Language.english
                            ? categories[index]
                            : russianCategories[index],
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: language == Language.english
                              ? 'KanitItalic'
                              : 'Comfortaa',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          //separatorBuilder: (BuildContext context, int index) =>
          //    const Divider(),
        ),
      ),
    );
  }
}
