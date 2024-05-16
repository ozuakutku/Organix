import 'package:flutter/material.dart';
import '../../widgets/chat_bubble.dart';
import '../../utils/constants.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organix Chatbot', style: TextStyle(color: kPrimaryColor)),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: [
                ChatBubble(
                    message: 'Merhaba! Size nasıl yardımcı olabilirim?',
                    isUser: false),
                ChatBubble(
                    message: 'Alışveriş listesi oluşturmak istiyorum.',
                    isUser: true),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Mesajınızı yazın',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Mesaj gönderme işlevi
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }
}
