import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'FirstScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              language == 'English'
                  ? 'Choose the language of app'
                  : 'Выберете язык приложения',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: language == 'English' ? 'KanitItalic' : 'Comfortaa',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                language == 'English' ? 'English' : 'Английский',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily:
                      language == 'Russian' ? 'Comfortaa' : 'KanitItalic',
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CupertinoSwitch(
                value: language == 'Russian',
                onChanged: (value) {
                  if (language == 'Russian') {
                    language = 'English';
                  } else {
                    language = 'Russian';
                  }
                  setState(() {});
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                language == 'English' ? 'Russian' : 'Русский',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily:
                      language == 'Russian' ? 'Comfortaa' : 'KanitItalic',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
