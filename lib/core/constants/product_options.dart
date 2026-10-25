import 'package:flutter/material.dart';

/// The API has no colors or sizes, so every product uses these options.
class ProductOptions {
  ProductOptions._();

  static const List<Color> colors = [
    Color(0xFF1F1F1F), // black
    Color(0xFF2F6BFF), // blue
    Color(0xFFE5484D), // red
  ];

  static const List<String> sizes = ['S', 'M', 'L', 'XL'];
}
