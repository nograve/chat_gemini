import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  void showSnackBar(String text, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(text),
        duration: duration ?? const Duration(seconds: 4),
      ),);
  }
}
