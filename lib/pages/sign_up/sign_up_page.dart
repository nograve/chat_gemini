import 'dart:async';
import 'dart:io';

import 'package:chat_gemini/constants.dart';
import 'package:chat_gemini/extensions/context_ext.dart';
import 'package:chat_gemini/pages/chat/chat_page.dart';
import 'package:chat_gemini/pages/profile/profile_store.dart';
import 'package:chat_gemini/pages/sign_in/sign_in_page.dart';
import 'package:chat_gemini/stores/auth_store.dart';
import 'package:chat_gemini/widgets/email_form_field.dart';
import 'package:chat_gemini/widgets/name_form_field.dart';
import 'package:chat_gemini/widgets/user_avatar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final AuthStore _authStore;
  final _profileStore = ProfileStore();

  final _imagePath = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _authStore = Provider.of<AuthStore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvatarWidget(imagePath: _imagePath),
                  NameFormField(
                    controller: _firstNameController,
                    isFirstName: true,
                  ),
                  NameFormField(
                    controller: _lastNameController,
                    isFirstName: false,
                  ),
                  EmailFormField(controller: _emailController),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: _passwordValidator,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    validator: _confirmPasswordValidator,
                  ),
                  SizedBox(height: 32.h),
                  Center(
                    child: ScopedListener<AuthStore, UserCredential?>(
                      store: _authStore,
                      onError: (context, error) =>
                          context.showSnackBar(error.toString()),
                      onState: (context, userCredential) {
                        final user = userCredential?.user;
                        if (user != null) {
                          unawaited(
                            _profileStore.saveUserData(
                                user.uid,
                                _firstNameController.text,
                                _lastNameController.text,
                                _imagePath.value != null
                                    ? File(_imagePath.value!)
                                    : null,),
                          );
                        }
                        context.pushReplacement(ChatPage.routeName);
                      },
                      child: ElevatedButton(
                        onPressed: _onSignUpPressed,
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Have an account already? ',
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: 'Sign in',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _onSignInPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onSignUpPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
          _authStore.signUp(_emailController.text, _passwordController.text),);
    }
  }

  void _onSignInPressed() {
    context.go(SignInPage.routeName);
  }
}
