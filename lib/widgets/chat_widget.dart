import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/model/api_call.dart';

class SpeechWidget extends StatefulWidget {
  const SpeechWidget({super.key});

  @override
  State<SpeechWidget> createState() => _SpeechWidgetState();
}

class _SpeechWidgetState extends State<SpeechWidget> {
  final OpenAIService openAIService = OpenAIService();
  String speechText = '';
  String answer = 'How can I assist you today?';
  late stt.SpeechToText _speech;
  bool _islistening = false;
  final FlutterTts tts = FlutterTts();
  //final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    settings(tts);
    askForPermissions();
    _speech = stt.SpeechToText();
  }

  Future askForPermissions() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }

    if (await Permission.microphone.isRestricted) {
      Permission.microphone.request();
    }
  }

  void reply() async {
    String test = '';
    test = await openAIService.chatGPTAPI(speechText);

    setState(() {
      answer = test;
    });
    speak(answer);
  }

  void _listen() async {
    if (!_islistening) {
      bool isAvailable = await _speech.initialize(
        // ignore: avoid_print
        onStatus: (status) => print('onStatus: $status'),
      );
      if (isAvailable) {
        setState(() {
          _islistening = true;
          speechText = '';
          answer = '';
        });
        _speech.listen(
          onResult: (result) => setState(() {
            speechText = '${result.recognizedWords}.';
          }),
        );
      }
    } else {
      setState(() => _islistening = false);
      _speech.stop();
      reply();
    }
  }

  Future speak(String test) async {
    await tts.speak(test);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 520,
          width: 310,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color.fromARGB(255, 145, 246, 219)])),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  speechText,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Scrollbar(
                  interactive: true,
                  radius: const Radius.circular(20),
                  thickness: 4,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      alignment: Alignment.topCenter,
                      child: Text(
                        answer,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 28,
        ),
        Center(
            child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(247, 255, 255, 255),
                  Color.fromARGB(242, 87, 248, 205)
                ]),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: IconButton(
              onPressed: () {
                _listen();
                if (_islistening == true) {
                  tts.stop();
                }
              },
              icon: Icon(
                Icons.mic,
                color: _islistening != true
                    ? const Color.fromARGB(255, 10, 10, 10)
                    : Colors.red,
              )),
        )),
      ],
    );
  }
}

Future settings(FlutterTts tts) async {
  await tts.setLanguage("en-AU");
  await tts.setPitch(0.8);
  await tts.setSpeechRate(0.5);
  await tts.setVolume(1);
  await tts.areLanguagesInstalled(["en-AU", "en-US"]);
}
