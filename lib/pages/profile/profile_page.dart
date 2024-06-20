import 'dart:async';
import 'dart:io';

import 'package:chat_gemini/models/user_data.dart';
import 'package:chat_gemini/pages/profile/profile_store.dart';
import 'package:chat_gemini/pages/sign_in/sign_in_page.dart';
import 'package:chat_gemini/stores/auth_store.dart';
import 'package:chat_gemini/widgets/name_form_field.dart';
import 'package:chat_gemini/widgets/user_avatar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthStore _authStore;
  final _profileStore = ProfileStore();

  final _imagePath = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool isImageFromNetwork = true;

  @override
  Widget build(BuildContext context) {
    _authStore = Provider.of<AuthStore>(context, listen: false);
    final user = _authStore.state?.user;
    if (user != null) {
      _profileStore.loadUserData(user.uid);
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 12.h, right: 12.w),
        child: ScopedBuilder<ProfileStore, UserData?>(
          store: _profileStore,
          onLoading: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          onState: (_, userData) {
            _firstNameController.text = userData?.firstName ?? '';
            _lastNameController.text = userData?.lastName ?? '';
            final profileImageUrl = userData?.profileImageUrl;
            if (profileImageUrl != null) {
              print(profileImageUrl);
              // _imagePath.value = profileImageUrl;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      UserAvatarWidget(
                        imagePath: _imagePath,
                        fromNetwork: true,
                      ),
                      NameFormField(
                        controller: _firstNameController,
                        isFirstName: true,
                      ),
                      NameFormField(
                        controller: _lastNameController,
                        isFirstName: false,
                      ),
                      SizedBox(height: 32.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: _onSavePressed,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
                ScopedConsumer<AuthStore, UserCredential?>(
                  store: _authStore,
                  onStateListener: (context, _) =>
                      context.pushReplacement(SignInPage.routeName),
                  onLoadingBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onStateBuilder: (_, __) => ElevatedButton(
                    onPressed: _onSignOutPressed,
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onSavePressed() {
    final user = _authStore.state?.user;

    if (user != null) {
      _profileStore.saveUserData(
        user.uid,
        _firstNameController.text,
        _lastNameController.text,
        _imagePath.value != null ? File(_imagePath.value!) : null,
      );
    }
  }

  void _onSignOutPressed() {
    unawaited(_authStore.signOut());
  }
}
