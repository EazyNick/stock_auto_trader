import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ChatBotScreen extends StatefulWidget {
  final String csrfToken; // CSRF 토큰을 받아오기 위해 생성자 추가
  final CookieJar cookieJar; // 쿠키 매니저를 받아오기 위해 생성자 추가

  ChatBotScreen({required this.csrfToken, required this.cookieJar});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController(); // 입력 필드 컨트롤러
  final List<Map<String, String>> _messages = []; // 메시지 저장 리스트
  late Dio _dio;
  late String csrfToken;

  @override
  void initState() {
    super.initState();
    csrfToken = widget.csrfToken; // CSRF 토큰 설정
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://fintech19190301.kro.kr/', // 서버의 기본 URL
        connectTimeout: Duration(seconds: 5), // 연결 타임아웃
        receiveTimeout: Duration(seconds: 20), // 응답 수신 타임아웃
      ),
    )..interceptors.addAll([LogInterceptor(responseBody: true), CookieManager(widget.cookieJar)]); // 로그 인터셉터와 쿠키 매니저 추가
  }

  Future<void> _sendMessage(String message) async {
    final url = 'api/stock_auto_trading_chatbot/'; // API 엔드포인트
    final headers = {
      'Content-Type': 'application/json',
      'X-CSRFToken': csrfToken,
      'Referer': 'https://fintech19190301.kro.kr/', // Referer 헤더 추가
    }; // 요청 헤더
    final body = {'message': message}; // 요청 바디

    try {
      final response = await _dio.post(url, data: body, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          _messages.add({'role': 'user', 'content': message});
          _messages.add({'role': 'bot', 'content': responseData['response']});
        });
      } else {
        print('Failed to get response: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Error occurred: $e');
      if (e.response != null) {
        print('Dio error response: ${e.response?.data}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'), // 앱바 타이틀
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['role'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['role'] == 'user' ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message['content'] ?? ''),
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
                      hintText: 'Enter your message...', // 입력 필드 힌트 텍스트
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      _sendMessage(message); // 메시지를 서버에 전송
                      _controller.clear(); // 입력 필드 초기화
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
