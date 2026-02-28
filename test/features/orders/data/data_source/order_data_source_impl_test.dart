import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/data/data_source/order_data_source_impl.dart';
import 'package:tracking_app/features/orders/data/models/response/order_response_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/product_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/product_response.dart';

import 'order_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late ApiClient apiClient;
  late OrdersDataSourceImpl dataSource;
  late OrderResponseDto orderResponse;
  late OrdersListDto ordersListDto;
  late ProductResponse productResponse;
  late ProductDto productDto;
  late Exception exception;

  setUp(() {
    apiClient = MockApiClient();
    dataSource = OrdersDataSourceImpl(apiClient);
    ordersListDto = OrdersListDto(id: "55");
    orderResponse = OrderResponseDto(orders: [ordersListDto, ordersListDto]);
    productDto = ProductDto(id: "55");
    productResponse = ProductResponse(product: productDto);
    exception = Exception("errors.unexpected");
  });
  test(
    'test getAllDriverOrders returns a list of OrdersListDto when successful',
    () async {
      when(
        apiClient.getAllDriverOrders(),
      ).thenAnswer((_) async => orderResponse);
      final result =
          await dataSource.getAllDriverOrders() as Success<List<OrdersListDto>>;
      expect(result, isA<Success<List<OrdersListDto>>>());
      expect(result.data, isA<List<OrdersListDto>>());
      expect(result.data, hasLength(2));
      expect(result.data, contains(ordersListDto));
      verify(apiClient.getAllDriverOrders()).called(1);
      verifyNoMoreInteractions(apiClient);
    },
  );
  test(
    'test getProductDetails returns a list of OrdersListDto when successful',
    () async {
      when(
        apiClient.getProductDetails("1"),
      ).thenAnswer((_) async => productResponse);
      final result =
          await dataSource.getProductDetails("1") as Success<ProductDto>;
      expect(result, isA<Success<ProductDto>>());
      expect(result.data, isA<ProductDto>());
      verify(apiClient.getProductDetails('1')).called(1);
      verifyNoMoreInteractions(apiClient);
    },
  );
  test('test getAllDriverOrders returns error when api call fails ', () async {
    when(apiClient.getAllDriverOrders()).thenThrow(exception);
    final result =
        await dataSource.getAllDriverOrders() as Failure<List<OrdersListDto>>;
    expect(result, isA<Failure<List<OrdersListDto>>>());
    expect(result.errorMessage, "errors.unexpected");
    verify(apiClient.getAllDriverOrders()).called(1);
    verifyNoMoreInteractions(apiClient);
  });
  test('test getProductDetails returns error when api call fails ', () async {
    when(apiClient.getProductDetails("1")).thenThrow(exception);
    final result =
        await dataSource.getProductDetails("1") as Failure<ProductDto>;
    expect(result, isA<Failure<ProductDto>>());
    expect(result.errorMessage, "errors.unexpected");
    verify(apiClient.getProductDetails("1")).called(1);
    verifyNoMoreInteractions(apiClient);
  });
}
