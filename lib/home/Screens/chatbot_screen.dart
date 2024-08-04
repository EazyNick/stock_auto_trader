import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 패키지 임포트

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final Dio _dio = Dio();

  final String _apiKey = dotenv.env['OPENAI_API_KEY']!; // 환경 변수에서 API 키를 불러옴

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;
      setState(() {
        _messages.add({'role': 'user', 'content': userMessage});
        _controller.clear();
      });

      String responseMessage = await _getChatGptResponse(userMessage);
      setState(() {
        _messages.add({'role': 'bot', 'content': responseMessage});
      });
    }
  }

  Future<String> _getChatGptResponse(String message) async {
    const String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';

    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'prompt': message,
          'max_tokens': 150,
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['text'].trim();
      } else {
        return 'Error: ${response.statusMessage}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _messages[index]['content']!,
                    style: TextStyle(
                      color: _messages[index]['role'] == 'user'
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
