import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatarWidget extends StatefulWidget {
  const UserAvatarWidget({
    required this.imagePath,
    this.fromNetwork = false,
    super.key,
  });

  final ValueNotifier<String?> imagePath;
  final bool fromNetwork;

  @override
  State<UserAvatarWidget> createState() => _UserAvatarWidgetState();
}

class _UserAvatarWidgetState extends State<UserAvatarWidget> {
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: ValueListenableBuilder<String?>(
          valueListenable: widget.imagePath,
          builder: (_, imagePath, __) {
            return CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: imagePath != null
                  ? widget.fromNetwork
                      ? NetworkImage(imagePath)
                      : FileImage(File(imagePath))
                  : null,
              child: imagePath == null
                  ? Icon(
                      Icons.add_a_photo,
                      color: Colors.grey[800],
                      size: 50,
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.imagePath.value = pickedFile.path;
    }
  }
}
