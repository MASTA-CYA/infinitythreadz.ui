import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Resolves a profile picture path to an image provider.
///
/// Bundled pictures live under `assets/`; photos taken with the camera are
/// a blob URL on web and a file path on mobile/desktop.
ImageProvider profileImageProvider(String path) {
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  }
  if (kIsWeb) {
    return NetworkImage(path);
  }
  return FileImage(File(path));
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    super.key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Center(
        child: Stack(
          children: [
            buildImage(),
            Positioned(
              bottom: 0,
              right: 4,
              child: buildEditIcon(color, bgColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: ResizeImage(
            profileImageProvider(imagePath),
            width: 1000,
            height: 1000,
          ),
          fit: BoxFit.cover,
          width: 200,
          height: 200,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color, Color bgColor) {
    return buildCircle(
      primary: color,
      bgColor: bgColor,
      child: IconButton(
        icon: Icon(
          isEdit ? Icons.add_a_photo : Icons.edit,
          color: Colors.white,
        ),
        onPressed: onClicked,
      ),
    );
  }

  Widget buildCircle({
    required Color primary,
    required Color bgColor,
    required Widget child,
  }) =>
      ClipOval(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary,
            ),
            child: child,
          ),
        ),
      );
}
