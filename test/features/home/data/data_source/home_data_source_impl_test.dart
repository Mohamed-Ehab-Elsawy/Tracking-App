import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source_impl.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';

import 'home_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late ApiClient apiClient;
  late HomeDataSourceImpl dataSourceImpl;
  setUp(() {
    apiClient = MockApiClient();
    dataSourceImpl = HomeDataSourceImpl(apiClient);
  });
  test('get orders from api should return list of orders', () async {
    //arrange
    final response = HomeResponseDto();
    when(apiClient.getOrders(1, 10)).thenAnswer((_) async => response);

    //act
    final result = await dataSourceImpl.getOrders(1, 10);

    //assert
    expect(result, isA<Result<HomeResponseDto>>());
    expect(result as Success<HomeResponseDto>, isA<Success<HomeResponseDto>>());
    expect((result).data, response);
    verify(apiClient.getOrders(1, 10)).called(1);
    verifyNoMoreInteractions(apiClient);
  });

  test('get orders from api should return error', () async {
    //arrange

    when(apiClient.getOrders(1, 10)).thenThrow(Exception());

    //act
    final result = await dataSourceImpl.getOrders(1, 10);

    //assert
    expect(result, isA<Result<HomeResponseDto>>());
    expect(result as Failure<HomeResponseDto>, isA<Failure<HomeResponseDto>>());
    verify(apiClient.getOrders(1, 10)).called(1);
    verifyNoMoreInteractions(apiClient);
  });
}
