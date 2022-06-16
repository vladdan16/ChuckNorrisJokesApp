import 'package:chuck_norris_joke_app/FirstScreen.dart';
import 'package:flutter/material.dart';
import 'FirstScreen.dart';

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
        backgroundColor: Colors.purple[400],
        title: Text(
          language == 'English' ? 'Choose categories' : 'Выбор категорий',
          style: TextStyle(
            fontSize: language == 'English' ? 30 : 25,
            fontFamily: language == 'English' ? 'Kanit' : 'Comfortaa',
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
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
              child: SizedBox(
                height: 40,
                child: Card(
                  key: UniqueKey(),
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Icon(
                        chooseCategories[index]
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: Colors.purple[400],
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        language == 'English'
                            ? categories[index]
                            : russianCategories[index],
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: language == 'English'
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
