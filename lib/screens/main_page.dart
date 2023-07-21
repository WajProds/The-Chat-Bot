import 'package:flutter/material.dart';
import 'package:text_to_speech/widgets/chat_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 19, 20, 28),
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: const Color.fromRGBO(23, 24, 34, 1),
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 55),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  'assets/icons/robot.png',
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              'Chat-Bot V1',
              style: TextStyle(
                  fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SpeechWidget()
        ],
      ),
    );
  }
}
