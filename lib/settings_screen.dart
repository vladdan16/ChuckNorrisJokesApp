import 'package:flutter/material.dart';
import 'first_screen.dart';

enum Language { english, russian }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Language languageView = language;
  ThemeMode themeView = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              height: language == Language.english ? 60 : 80,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                language == Language.english
                    ? 'Choose the language of app'
                    : 'Выберете язык приложения',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: language == Language.english ? 25 : 22,
                  fontFamily: language == Language.english
                      ? 'KanitItalic'
                      : 'Comfortaa',
                ),
              ),
            ),
            SegmentedButton<Language>(
              segments: const <ButtonSegment<Language>>[
                ButtonSegment<Language>(
                  value: Language.english,
                  label: Text("English"),
                ),
                ButtonSegment<Language>(
                  value: Language.russian,
                  label: Text("Russian"),
                ),
              ],
              selected: <Language>{languageView},
              onSelectionChanged: (Set<Language> newSelection) {
                languageView = newSelection.first;
                language = languageView;
                setState(() {});
                super.setState(() {});
              },
            ),
            const SizedBox(height: 30),
            Container(
              height: language == Language.english ? 60 : 80,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                language == Language.english
                    ? 'Choose theme of app'
                    : 'Выберете тему приложения',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: language == Language.english ? 25 : 22,
                  fontFamily: language == Language.english
                      ? 'KanitItalic'
                      : 'Comfortaa',
                ),
              ),
            ),
            SegmentedButton<ThemeMode>(
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text("Light"),
                  icon: Icon(Icons.brightness_7),
                ),
                ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text("Dark"),
                    icon: Icon(Icons.brightness_4)),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text("Dynamic"),
                  icon: Icon(Icons.brightness_auto),
                ),
              ],
              selected: <ThemeMode>{themeView},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                themeView = newSelection.first;
                // switch (themeView) {
                //   case ThemeMode.light:
                //     EasyDynamicTheme.of(context).changeTheme(dynamic: false, dark: false);
                //     break;
                //   case ThemeMode.dark:
                //     EasyDynamicTheme.of(context).changeTheme(dynamic: false, dark: true);
                //     break;
                //   case ThemeMode.system:
                //     EasyDynamicTheme.of(context).changeTheme(dynamic: true);
                // }
                setState(() {});
                super.setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
