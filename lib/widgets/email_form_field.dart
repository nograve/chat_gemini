import 'package:flutter/material.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: _emailValidator,
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
