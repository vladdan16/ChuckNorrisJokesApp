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
  "travel"
];

class JokesFilter extends StatefulWidget {
  const JokesFilter({Key? key}) : super(key: key);

  @override
  State<JokesFilter> createState() => _JokesFilterState();
}

class _JokesFilterState extends State<JokesFilter> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose categories',
          style: TextStyle(
            fontFamily: "Kanit",
            fontSize: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              key: UniqueKey(),
              margin: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    icon: Icon(
                      chooseCategories[index]
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color: Colors.purple[400],
                      size: 30,
                    ),
                    onPressed: () {
                      if (chooseCategories[index]) {
                        chosenCategories.remove(chooseCategories.elementAt(index));
                        chooseCategories[index] = false;
                      } else {
                        chooseCategories[index] = true;
                        chosenCategories.add(categories[index]);
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    categories[index],
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'KanitItalic',
                    ),
                  ),
                ],
              ),
              // ListTile(
              //   title: Text(
              //     categories[index],
              //     style: const TextStyle(
              //       fontFamily: 'KanitItalic',
              //       fontSize: 20,
              //     ),
              //   ),
              //   leading: IconButton(
              //     icon: Icon(chooseCategories[index]
              //         ? Icons.check_box_outlined
              //         : Icons.check_box_outline_blank_rounded),
              //     color: Colors.purple[400],
              //     onPressed: () {
              //       chooseCategories[index] = !chooseCategories[index];
              //       if (chooseCategories[index]) {
              //         chosenCategories.add(categories[index]);
              //       } else {
              //         chooseCategories.remove(categories[index]);
              //       }
              //       setState(() {});
              //     },
              //   ),
              // ),
            );
          },
          //separatorBuilder: (BuildContext context, int index) =>
          //    const Divider(),
        ),
      ),
    );
  }
}
