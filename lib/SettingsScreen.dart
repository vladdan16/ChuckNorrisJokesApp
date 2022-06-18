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
            height: 50,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              language == 'en'
                  ? 'Choose the language of app'
                  : 'Выберете язык приложения',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: language == 'en' ? 25 : 22,
                fontFamily: language == 'en' ? 'KanitItalic' : 'Comfortaa',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  language == 'en' ? 'English' : 'Английский',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: language == 'en' ? 25 : 22,
                    fontFamily:
                        language == 'ru' ? 'Comfortaa' : 'KanitItalic',
                    color: Colors.black,
                  ),
                ),
              ),

              CupertinoSwitch(
                value: language == 'ru',
                onChanged: (value) {
                  if (language == 'ru') {
                    language = 'rn';
                  } else {
                    language = 'ru';
                  }
                  setState(() {});
                },
              ),
              SizedBox(
                width: 150,
                child: Text(
                  language == 'en' ? 'Russian' : 'Русский',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: language == 'en' ? 25 : 22,
                    fontFamily:
                        language == 'ru' ? 'Comfortaa' : 'KanitItalic',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
