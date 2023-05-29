import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import 'first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EasyDynamicThemeWidget(child: const MyClass()));
}

const _brandColor = Colors.purple;

class MyClass extends StatelessWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: _brandColor,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: _brandColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChuckNorrisJokesApp',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Kanit',
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Kanit',
            colorScheme: darkColorScheme,
          ),
          themeMode: EasyDynamicTheme.of(context).themeMode,
          home: const HomePage(title: 'Tinder with Chuck'),
        );
      },
    );
  }
}
