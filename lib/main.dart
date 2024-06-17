import 'package:chat_gemini/application/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyAN9ZFiWw92upqUB2A8EF8iaK9lWAxSpLk');
  runApp(const App());
}
