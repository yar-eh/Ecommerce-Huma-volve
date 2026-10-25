import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../../core/theme.dart';

class ProfileAvatar extends StatelessWidget {
  final Uint8List? bytes;
  final double radius;

  const ProfileAvatar({super.key, required this.bytes, required this.radius});

  @override
  Widget build(BuildContext context) {
    final data = bytes;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.background,
      child: data == null
          ? Icon(Icons.person, size: radius, color: AppTheme.primary)
          : ClipOval(
              child: Image.memory(
                data,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
