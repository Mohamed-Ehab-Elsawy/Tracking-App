import 'package:flutter/material.dart';

extension ServerDrivenStringX on String {
  Color get toColor {
    var hex = trim().toLowerCase();

    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    } else if (hex.startsWith('0x')) {
      hex = hex.substring(2);
    }

    if (hex.length == 6) {
      hex = 'ff$hex';
    }

    if (hex.length != 8) {
      return Colors.black;
    }

    return Color(int.parse(hex, radix: 16));
  }

  FontWeight get toFontWeight {
    switch (toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'medium':
      case 'w500':
        return FontWeight.w500;
      case 'light':
      case 'w300':
        return FontWeight.w300;
      default:
        return FontWeight.normal;
    }
  }
}
