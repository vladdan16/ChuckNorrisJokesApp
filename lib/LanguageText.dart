import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'FirstScreen.dart';

late String token;
late String folderId;
late String addressOfToken;
bool ifReadToken = false;
bool ifReadAddress = false;

Future<void> getTokenFromFile() async {
  var input = await rootBundle.loadString('assets/secret_token.json');
  var map = convert.jsonDecode(input) as Map<String, dynamic>;
  token = map['token'];
  folderId = map['folderId'];
}

Future<void> getAddressFromFile() async {
  var input = await rootBundle.loadString('assets/address.json');
  var map = convert.jsonDecode(input) as Map<String, dynamic>;
  addressOfToken = map['address'];
}

Future<void> getTokenFromGoogleDrive() async {
  if (!ifReadAddress) {
    await getAddressFromFile();
    ifReadAddress = true;
  }
  var url = Uri.parse(addressOfToken);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var input = response.body;
    var map = convert.jsonDecode(input) as Map<String, dynamic>;
    token = map['token'];
    folderId = map['folderId'];
  } else {
    if (kDebugMode) {
      print(response.statusCode);
    }
  }
}

Future<String> translateText(
    String text, String lang, String targetLang) async {
  if (lang != targetLang) {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      if (!ifReadToken) {
        await getTokenFromGoogleDrive();
        ifReadToken = true;
      }

      //translate the text
      var url = Uri.parse(
          'https://translate.api.cloud.yandex.net/translate/v2/translate');
      final response = await http.post(
        url,
        body: convert.jsonEncode({
          "targetLanguageCode": targetLang,
          "texts": [text],
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
        text = map['text'];
      } else if (response.statusCode == 401) {
        text = 'Unauthorized';
      } else {
        if (kDebugMode) {
          print("Couldn't translate");
          print(response.statusCode);
        }
        text = "Unknown error, please try English version of app";
      }
    } else {
      text = "Check your internet connection";
    }
  }
  return text;
}

class LanguageText extends StatefulWidget {
  LanguageText(
      {Key? key,
      required this.text,
      required this.size,
      this.fontFamily,
      this.color})
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
    if (language == 'ru') {
      if (!ifReadToken) {
        await getTokenFromGoogleDrive();
        ifReadToken = true;
      }
      try {
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
        } else if (response.statusCode == 401) {
          widget.text = 'Unauthorized';
        } else {
          if (kDebugMode) {
            print("Couldn't translate");
            print(response.statusCode);
          }
          widget.text = "Unknown error, please try English version of app";
        }
      } catch (e) {
        widget.text = "Check your internet connection";
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
              fontFamily: language == 'en' ? widget.fontFamily : 'Comfortaa',
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Text(
              widget.text,
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
                fontFamily: language == 'en' ? widget.fontFamily : 'Comfortaa',
              ),
            );
          }
        }
      },
    );
  }
}
