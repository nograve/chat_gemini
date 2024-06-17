import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static const routeName = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _gemini = Gemini.instance;
  final TextEditingController _controller = TextEditingController();
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Gemini')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _output,
                    textAlign: TextAlign.left,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => onSendButtonPressed(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSendButtonPressed(String input) {
    _gemini.streamGenerateContent(input).listen((value) {
      setState(() {
        _output = value.output ?? '';
      });
    }).onError((Object? e) {
      log('streamGenerateContent exception', error: e);
    });
  }
}
