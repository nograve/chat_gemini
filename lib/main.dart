import 'package:chat_gemini/application/app.dart';
import 'package:chat_gemini/firebase_options.dart';
import 'package:chat_gemini/stores/auth_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Gemini.init(apiKey: 'AIzaSyAN9ZFiWw92upqUB2A8EF8iaK9lWAxSpLk');
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthStore()),
      ],
      child: const App(),
    ),
  );
}
