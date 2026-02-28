import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/data/data_source/order_data_source.dart';
import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/product_dto.dart';
import 'package:tracking_app/features/orders/data/repository/order_repo_impl.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/domain/entity/product_entity.dart';

import 'order_repo_impl_test.mocks.dart' show MockOrdersDataSource;

@GenerateMocks([OrdersDataSource])
void main() {
  late OrderRepoImpl orderRepoImpl;
  late MockOrdersDataSource dataSource;
  late Exception exception;
  late OrdersListDto ordersListDto;

  setUp(() {
    dataSource = MockOrdersDataSource();
    orderRepoImpl = OrderRepoImpl(dataSource);
    exception = Exception("errors.unexpected");
    ordersListDto = OrdersListDto(id: "55");
    provideDummy<Result<List<OrdersListDto>>>(
      Success<List<OrdersListDto>>([ordersListDto, ordersListDto]),
    );
    provideDummy<Result<ProductDto>>(Success<ProductDto>(ProductDto(id: "1")));
  });

  test(
    'getAllDriverOrders returns a list of OrdersListEntity when successful',
    () async {
      when(dataSource.getAllDriverOrders()).thenAnswer(
        (_) async =>
            Success<List<OrdersListDto>>([ordersListDto, ordersListDto]),
      );

      final result =
          await orderRepoImpl.getAllDriverOrders()
              as Success<List<OrdersListEntity>>;
      expect(result, isA<Success<List<OrdersListEntity>>>());
      expect(result.data[0].id, "55");
      expect(result.data[1].id, "55");
      verify(dataSource.getAllDriverOrders()).called(1);
    },
  );
  test('getAllDriverOrders returns a error message when fail', () async {
    when(dataSource.getAllDriverOrders()).thenAnswer(
      (_) async => Failure<List<OrdersListDto>>(exception.toString()),
    );

    final result =
        await orderRepoImpl.getAllDriverOrders()
            as Failure<List<OrdersListEntity>>;
    expect(result, isA<Failure<List<OrdersListEntity>>>());
    expect(result.errorMessage, equals(exception.toString()));
    verify(dataSource.getAllDriverOrders()).called(1);
  });

  test(
    'getProductDetails returns a list of ProductEntity when successful',
    () async {
      when(
        dataSource.getProductDetails("1"),
      ).thenAnswer((_) async => Success<ProductDto>(ProductDto(id: "1")));

      final result =
          await orderRepoImpl.getProductDetails("1") as Success<ProductEntity>;
      expect(result, isA<Success<ProductEntity>>());
      expect(result.data.id, "1");
      expect(result.data.id, "1");
      verify(dataSource.getProductDetails("1")).called(1);
    },
  );
  test('getProductDetails returns a error message when fail', () async {
    when(
      dataSource.getProductDetails("1"),
    ).thenAnswer((_) async => Failure<ProductDto>(exception.toString()));

    final result =
        await orderRepoImpl.getProductDetails("1") as Failure<ProductEntity>;
    expect(result, isA<Failure<ProductEntity>>());
    expect(result.errorMessage, equals(exception.toString()));
    verify(dataSource.getProductDetails("1")).called(1);
  });
}
