import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/models/requests/driver_login_request_dto.dart';
import 'package:tracking_app/core/api/models/responses/driver_login_response_dto.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source_impl.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late DioException dioException;

  setUp(() {
    mockApiClient = MockApiClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockApiClient);
    dioException = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.connectionError,
    );
  });

  group("Test Login cases", () {
    late String email, password;
    late DriverLoginRequestDTO requestDTO;
    late DriverLoginResponseDTO responseDTO;
    setUp(() {
      email = "mooehab03@gmail.com";
      password = "Mohamed@123";
      requestDTO = DriverLoginRequestDTO(email, password);
      responseDTO = DriverLoginResponseDTO(token: "token", message: "success");
    });
    test("Success Login case it should return user token", () async {
      // arrange
      when(
        mockApiClient.login(requestDTO),
      ).thenAnswer((_) async => responseDTO);
      // act
      final result =
          await authRemoteDataSourceImpl.login(email, password)
              as Success<String>;
      // assert
      expect(result, isA<Success<String>>());
      expect(result.data, responseDTO.token);
      verify(mockApiClient.login(requestDTO)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test("Failure Login case it should return error message", () async {
      // arrange
      when(mockApiClient.login(requestDTO)).thenThrow(dioException);
      // act
      final result = await authRemoteDataSourceImpl.login(email, password);
      // assert
      expect(result, isA<Failure<String>>());
      expect(
        (result as Failure<String>).errorMessage,
        'errors.connectionError',
      );
      verify(mockApiClient.login(requestDTO)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
