import 'package:flutter/material.dart';

import 'package:text_to_speech/screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBot',
      theme: ThemeData(
          fontFamily: 'Sans',
          primarySwatch: Colors.blue,
          highlightColor:const Color.fromARGB(255, 90, 247, 200)),
      home: const MainPage(),
    );
  }
}
