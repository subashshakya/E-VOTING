import 'package:evoting_ui/user_view/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class LanguageSelection extends StatelessWidget {
  final List locale = [
    {
      'name': 'English',
      'locale': const Locale('en', 'US'),
    },
    {'name': 'नेपाली', 'locale': const Locale('np', 'NP')}
  ];

  // LanguageSelection({super.key});

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  String sendLocalizationLetter(String text) {
    log(text);
    if (text == 'en_US') {
      return 'E';
    } else {
      return 'N';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   title: const Text('LANGUAGE SELECTION SCREEN',
            //       textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
            // ),
            body: Card(
      elevation: 10,
      child: Container(
          color: Colors.black12,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.all(30),
          height: 700,
          child: Column(children: [
            const SizedBox(height: 100),
            const Text('Please Select Language',
                style: TextStyle(fontSize: 30)),
            const Text('(कृपया भाषा छनोट गर्नुस)',
                style: TextStyle(fontSize: 30)),
            const SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          updateLanguage(locale[index]['locale']);
                          String localizationLetter = sendLocalizationLetter(
                              locale[index]['locale'].toString());
                          log(localizationLetter);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UserAuthentication(localizationLetter)));
                        },
                        child: Text(locale[index]['name'],
                            style: const TextStyle(fontSize: 17)),
                      ),
                    );
                  },
                  itemCount: locale.length),
            )
          ])),
    )));
  }
}
