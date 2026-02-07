import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/error_handling/model/base_response_result_dto.dart';

void main() {
  group('SuccessResponseDto', () {
    const mockMessage = "Operation successful";
    const mockJson = {"message": mockMessage};

    test('should support value equality', () {
      expect(
        const SuccessResponseDto(message: mockMessage),
        const SuccessResponseDto(message: mockMessage),
      );
    });

    test('fromJson should return a valid model', () {
      final result = SuccessResponseDto.fromJson(mockJson);

      expect(result, isA<SuccessResponseDto>());
      expect(result.message, mockMessage);
    });

    test('toJson should return a JSON map containing proper data', () {
      const dto = SuccessResponseDto(message: mockMessage);
      final result = dto.toJson();

      expect(result, mockJson);
    });

    test('props should contain message', () {
      const dto = SuccessResponseDto(message: mockMessage);
      expect(dto.props, [mockMessage]);
    });
  });

  group('FailureResponseDto', () {
    const mockError = "Internal Server Error";
    const mockJson = {"error": mockError};

    test('should support value equality', () {
      expect(
        const FailureResponseDto(error: mockError),
        const FailureResponseDto(error: mockError),
      );
    });

    test('fromJson should return a valid model', () {
      final result = FailureResponseDto.fromJson(mockJson);

      expect(result, isA<FailureResponseDto>());
      expect(result.error, mockError);
    });

    test('toJson should return a JSON map containing proper data', () {
      const dto = FailureResponseDto(error: mockError);
      final result = dto.toJson();

      expect(result, mockJson);
    });

    test('props should contain error', () {
      const dto = FailureResponseDto(error: mockError);
      expect(dto.props, [mockError]);
    });
  });
}
