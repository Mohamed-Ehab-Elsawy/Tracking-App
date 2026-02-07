import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/extensions/string_server_driven_extension.dart';

void main() {
  group('toColor', () {
    test('parses hex color with # prefix', () {
      final color = '#ff0000'.toColor;

      expect(color, const Color(0xffff0000));
    });

    test('parses hex color with 0x prefix', () {
      final color = '0xFF00FF00'.toColor;

      expect(color, const Color(0xff00ff00));
    });

    test('adds alpha channel when hex is 6 characters', () {
      final color = '0000ff'.toColor;

      expect(color, const Color(0xff0000ff));
    });

    test('handles uppercase hex', () {
      final color = '#ABCDEF'.toColor;

      expect(color, const Color(0xffabcdef));
    });

    test('trims whitespace', () {
      final color = '  #ffffff  '.toColor;

      expect(color, const Color(0xffffffff));
    });

    test('returns black for invalid hex length', () {
      final color = '12345'.toColor;

      expect(color, Colors.black);
    });

    test('returns black for non-hex value', () {
      final color = 'not-a-color'.toColor;

      expect(color, Colors.black);
    });
  });

  group('toFontWeight', () {
    test('returns bold', () {
      expect('bold'.toFontWeight, FontWeight.bold);
    });

    test('returns medium for medium and w500', () {
      expect('medium'.toFontWeight, FontWeight.w500);
      expect('w500'.toFontWeight, FontWeight.w500);
    });

    test('returns light for light and w300', () {
      expect('light'.toFontWeight, FontWeight.w300);
      expect('w300'.toFontWeight, FontWeight.w300);
    });

    test('is case-insensitive', () {
      expect('BOLD'.toFontWeight, FontWeight.bold);
    });

    test('returns normal for unknown value', () {
      expect('unknown'.toFontWeight, FontWeight.normal);
    });

    test('returns normal for empty string', () {
      expect(''.toFontWeight, FontWeight.normal);
    });
  });
}
