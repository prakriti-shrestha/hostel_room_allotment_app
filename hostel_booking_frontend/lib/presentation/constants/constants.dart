import 'package:flutter/material.dart';

class Constants {
  static BoxDecoration buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
