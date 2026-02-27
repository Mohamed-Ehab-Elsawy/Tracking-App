import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/domain/repository/order_repo.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_orders_history.dart';
import 'get_orders_history_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  late MockOrderRepo mockOrderRepo;
  late GetOrdersHistoryUseCase useCase;
  late Exception failure;
  late OrdersListEntity ordersListEntity;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    useCase = GetOrdersHistoryUseCase(mockOrderRepo);
    ordersListEntity = OrdersListEntity(id: "1");
    provideDummy<Result<List<OrdersListEntity>>>(
      Success([ordersListEntity, ordersListEntity]),
    );
    failure = Exception("errors.unexpected");
  });

  group('GetProductByIdUseCase', () {
    test(
      'should return OrdersListEntity when repository call is successful',
      () async {
        when(mockOrderRepo.getAllDriverOrders()).thenAnswer(
          (_) async => Success<List<OrdersListEntity>>([
            ordersListEntity,
            ordersListEntity,
          ]),
        );
        final result = await useCase.call();
        expect(result, isA<Success<List<OrdersListEntity>>>());
        verify(useCase.call()).called(1);
      },
    );

    test('should return Failure when repository call fails', () async {
      when(mockOrderRepo.getAllDriverOrders()).thenAnswer(
        (_) async => Failure<List<OrdersListEntity>>(failure.toString()),
      );

      final result = await useCase() as Failure<List<OrdersListEntity>>;
      expect(result.errorMessage, equals(failure.toString()));
      verify(useCase.call()).called(1);
    });
  });
}
