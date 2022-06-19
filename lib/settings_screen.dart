import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'first_screen.dart';

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
            height: language == 'en' ? 60 : 70,
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
          SizedBox(
            height: language == 'en' ? 50 : 40,
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
                    language = 'en';
                  } else {
                    language = 'ru';
                  }
                  setState(() {});
                  super.setState(() {});
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
