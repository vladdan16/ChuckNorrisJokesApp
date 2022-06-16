
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';

import 'FirstScreen.dart';

late String token;
late String folderId;
bool ifRead = false;

Future<void> readToken() async {
  var input = await rootBundle.loadString('assets/secret_token.json');
  var map = convert.jsonDecode(input) as Map<String, dynamic>;
  token = map['token'];
  folderId = map['folderId'];
}

class LanguageText extends StatefulWidget {
  LanguageText({Key? key, required this.text, required this.size, this.fontFamily, this.color})
      : super(key: key);

  String text;

  final double size;

  String? fontFamily = 'KanitItalic';

  Color? color = Colors.black;

  @override
  State<LanguageText> createState() => _LanguageTextState();
}

class _LanguageTextState extends State<LanguageText> {
  Future<void> translateText() async {
    if (language == 'Russian') {
      if (!ifRead) {
        await readToken();
        ifRead = true;
      }
      //translate the text
      var url = Uri.parse(
          'https://translate.api.cloud.yandex.net/translate/v2/translate');
      final response = await http.post(
        url,
        body: convert.jsonEncode({
          "targetLanguageCode": "ru",
          "texts": [widget.text],
          "folderId": folderId,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes))
                as Map<String, dynamic>;
        if (kDebugMode) {
          print(jsonResponse);
        }
        var list = jsonResponse['translations'] as List;
        var map = list[0] as Map<String, dynamic>;
        widget.text = map['text'];
      } else {
        if (kDebugMode) {
          print("Couldn't translate");
        }
      }
    }
  }

  @override
  void initState() {
    translateText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: translateText(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (kDebugMode) {
          print(snapshot);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Подождите, идет перевод',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.size,
              color: Colors.black,
              fontFamily: language == 'English' ? widget.fontFamily : 'Comfortaa',
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Text(
              'Error',
              textAlign: TextAlign.center,
              style: TextStyle(
              fontSize: widget.size,
              fontFamily: widget.fontFamily,
            ),
            );
          } else {
            return Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.color,
                fontSize: widget.size,
                fontFamily: language == 'English' ? widget.fontFamily : 'Comfortaa',
              ),
            );
          }
        }
      },
    );
  }
}
