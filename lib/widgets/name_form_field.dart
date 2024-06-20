import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  const NameFormField({
    required this.controller,
    required this.isFirstName,
    super.key,
  });

  final TextEditingController controller;
  final bool isFirstName;

  @override
  Widget build(BuildContext context) {
    final nameType = isFirstName ? 'First' : 'Last';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: '$nameType name'),
      validator: (value) => _nameValidator(value, nameType),
    );
  }

  String? _nameValidator(String? value, String nameType) {
    if (value == null || value.isEmpty) {
      return '$nameType name required';
    }

    final trimmedText = value.trim();
    if (trimmedText.isEmpty) {
      return '$nameType name required';
    } else if (value.length < 2 || value.length > 20) {
      return '$nameType name must have length from 2 to 20';
    } else if (trimmedText.contains(RegExp('[0-9]'))) {
      return '$nameType name cannot contain digits';
    }

    return null;
  }
}
