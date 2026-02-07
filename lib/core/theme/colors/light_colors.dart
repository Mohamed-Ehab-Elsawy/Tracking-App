import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/app_colors.dart';

class LightColors implements AppColors {
  const LightColors();

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get error => const Color(0xFFCC1010);

  @override
  MaterialColor get primary => const MaterialColor(0xFFD21E6A, <int, Color>{
    0: Color(0xFFD21E6A),
    10: Color(0xFFf6d2e1),
    20: Color(0xFFf0b4cd),
    30: Color(0xFFe98fb5),
    40: Color(0xFFe1699c),
    50: Color(0xFFda4483),
    60: Color(0xFFaf1958),
    70: Color(0xFF8c1447),
    80: Color(0xFF690f35),
    90: Color(0xFF460a23),
    100: Color(0xFF2a0615),
  });

  @override
  MaterialColor get secondary => const MaterialColor(0xFFf9f9f9, <int, Color>{
    0: Color(0xFFf9f9f9),
    10: Color(0xFFfefefe),
    20: Color(0xFFfdfdfd),
    30: Color(0xFFfcfcfc),
    40: Color(0xFFfbfbfb),
    50: Color(0xFFfafafa),
    60: Color(0xFFd0d0d0),
    70: Color(0xFFa6a6a6),
    80: Color(0xFF7D7D7D),
    90: Color(0xFF535353),
    100: Color(0xFF323232),
  });

  @override
  Color get success => const Color(0xFF0CB359);

  @override
  MaterialColor get surface => const MaterialColor(0xFF0c1015, <int, Color>{
    0: Color(0xFF0c1015),
    10: Color(0xFFcecfd0),
    20: Color(0xFFaeafb1),
    30: Color(0xFF86888a),
    40: Color(0xFF5d6063),
    50: Color(0xFF34383c),
    60: Color(0xFF0a0d12),
    70: Color(0xFF080b0e),
    80: Color(0xFF06080b),
    90: Color(0xFF040507),
    100: Color(0xFF020304),
  });

  @override
  Color get grey => const Color(0xFF535353);

  @override
  Color get lightPink => const Color(0xFFF9ECF0);

  @override
  Color get textColor => Colors.black;

  @override
  List<Color> get defaultRainbowColors => const [
    Color(0xFFf6d2e1),
    Color(0xFFf0b4cd),
    Color(0xFFe98fb5),
    Color(0xFFe1699c),
    Color(0xFFda4483),
    Color(0xFFaf1958),
    Color(0xFF8c1447),
  ];
}
