import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';
import 'package:tracking_app/features/home/domain/use_case/get_orders_use_case.dart';

import 'get_orders_use_case_test.mocks.dart';

@GenerateMocks([HomeRepo])
void main() {
  late HomeRepo mockRepo;
  late GetOrdersUseCase useCase;

  setUp(() {
    mockRepo = MockHomeRepo();
    useCase = GetOrdersUseCase(mockRepo);
    provideDummy<Result<List<HomeOrderEntity>>>(Success([]));
  });

  final tOrdersList = [
    HomeOrderEntity(
      orderId: '1',
      status: 'pending',
      totalPrice: 100.0,
      storeName: 'elevate',
      storeAddress: 'cairo',
      storeImage: 'storeImage',
      userName: 'abdo',
      userImage: 'userImage',
      userAddress: 'cairo',
    ),
  ];

  group('GetOrdersUseCase Tests', () {
    test(
      'should call getOrders from repository when invoke is called',
      () async {
        // 1. Arrange
        when(
          mockRepo.getOrders(1, 10),
        ).thenAnswer((_) async => Success(tOrdersList));

        // 2. Act
        final result = await useCase.invoke(1, 10);

        // 3. Assert
        expect(result, isA<Success<List<HomeOrderEntity>>>());
        expect((result as Success).data, tOrdersList);

        verify(mockRepo.getOrders(1, 10)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('should return Failure when repository returns Failure', () async {
      // 1. Arrange
      const errorMsg = "Server Error";
      when(
        mockRepo.getOrders(1, 10),
      ).thenAnswer((_) async => Failure(errorMsg));

      // 2. Act
      final result = await useCase.invoke(1, 10);

      // 3. Assert
      expect(result, isA<Failure>());
      expect((result as Failure).errorMessage, errorMsg);

      verify(mockRepo.getOrders(1, 10)).called(1);
    });
  });
}
