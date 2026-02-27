import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/mapper/apply_rsponse_mappr.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';

void main() {
  test('apply response mapper test success case ', () async {
    // arrange
    final model = ApplyResponse(message: "success", token: "token");
    // act
    final result = model.toEntity();
    // assert
    expect(result.message, model.message);
    expect(result.token, model.token);
  });
  test('apply response mapper test null case ', () async {
    // arrange
    final model = ApplyResponse(message: null, token: null);
    // act
    final result = model.toEntity();
    // assert
    expect(result.message, isNull);
    expect(result.token, isNull);
  });
}
