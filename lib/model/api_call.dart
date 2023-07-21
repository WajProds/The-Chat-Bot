import 'dart:convert';

import 'package:http/http.dart' as http;

const token = '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';

class OpenAIService {
  String content = '';

  Future<String> chatGPTAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                'role': 'user',
                'content': 'Answer this prompt in only max 350 words: $prompt'
              }
            ],
          },
        ),
      );

      if (res.statusCode == 200) {
        content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
      }

      return content;
    } catch (e) {
      return e.toString();
    }
  }
}
