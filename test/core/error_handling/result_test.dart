import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/error_handling/result.dart';

void main() {
  group('Result Equality', () {
    test('Success objects with same data should be equal', () {
      expect(Success(10), Success(10));
      expect(Success(10), isNot(Success(11)));
    });

    test('Failure objects with same message should be equal', () {
      expect(Failure('error'), Failure('error'));
    });
  });
}
