import 'dart:io';

import 'package:chat_gemini/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:http/http.dart' as http;

class ProfileStore extends Store<UserData?> {
  ProfileStore() : super(null);

  final _firebaseStorage = FirebaseStorage.instance;

  Future<void> loadUserData(String userId) async {
    setLoading(true);

    var firstName = '';
    var lastName = '';
    var profileImageUrl = '';

    final userDataUrl = await _firebaseStorage
        .ref('users/$userId/user_data.txt')
        .getDownloadURL();
    final response = await http.get(Uri.parse(userDataUrl));
    if (response.statusCode == 200) {
      final userData = response.body.split(' ');
      firstName = userData[0];
      lastName = userData[1];
    }

    profileImageUrl = await FirebaseStorage.instance
        .ref('users/$userId/profile_image.jpg')
        .getDownloadURL();

    update(UserData(
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: profileImageUrl,
    ),);

    setLoading(false);
  }

  Future<void> saveUserData(
      String userId, String firstName, String lastName, File? imageFile,) async {
    setLoading(true);

    await _firebaseStorage
        .ref('users/$userId/user_data.txt')
        .putString('$firstName $lastName');

    if (imageFile != null) {
      await FirebaseStorage.instance
          .ref('users/$userId/profile_image.jpg')
          .putFile(imageFile);
    }

    update(UserData(
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: imageFile?.path,
    ),);

    setLoading(false);
  }
}
