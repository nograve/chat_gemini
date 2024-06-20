import 'dart:async';

import 'package:chat_gemini/constants.dart';
import 'package:chat_gemini/extensions/context_ext.dart';
import 'package:chat_gemini/pages/chat/chat_page.dart';
import 'package:chat_gemini/pages/sign_up/sign_up_page.dart';
import 'package:chat_gemini/stores/auth_store.dart';
import 'package:chat_gemini/widgets/email_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final AuthStore _authStore;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _authStore = Provider.of<AuthStore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmailFormField(controller: _emailController),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: _passwordValidator,
                  ),
                  SizedBox(height: 32.h),
                  Center(
                    child: ScopedListener<AuthStore, UserCredential?>(
                      store: _authStore,
                      onError: (context, error) =>
                          context.showSnackBar(error.toString()),
                      onState: (context, _) =>
                          context.pushReplacement(ChatPage.routeName),
                      child: ElevatedButton(
                        onPressed: _onSignInPressed,
                        child: const Text('Sign In'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _onSignUpPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void _onSignInPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
          _authStore.signIn(_emailController.text, _passwordController.text),);
    }
  }

  void _onSignUpPressed() {
    context.go(SignUpPage.routeName);
  }
}
