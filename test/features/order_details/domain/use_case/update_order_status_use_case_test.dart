import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';
import 'package:tracking_app/features/order_details/domain/use_case/update_order_status_use_case.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import 'update_order_status_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OrderDetailsRepository>()])
void main() {
  late UpdateOrderStatusUseCase useCase;
  late MockOrderDetailsRepository mockRepo;

  setUp(() {
    mockRepo = MockOrderDetailsRepository();
    useCase = UpdateOrderStatusUseCase(mockRepo);
  });

  group('UpdateOrderStatusUseCase Tests', () {
    final tOrderEntity = ActiveOrderDto(
      orderId: "123",
      storeName: "Senior Flutter Store",
    );
    final status = OrderStatus.accepted;
    test(
      'should call updateOrderStatus from repository and return Success',
      () async {
        // Arrange
        provideDummy<Result<ActiveOrderDto>>(Success(tOrderEntity));
        when(
          mockRepo.updateOrderStatus(status),
        ).thenAnswer((_) async => Success(tOrderEntity));

        // Act
        final result = await useCase.call(status);

        // Assert
        expect(result, isA<Success<ActiveOrderDto>>());
        expect((result as Success).data, tOrderEntity);

        // Verify the repository was called exactly once
        verify(mockRepo.updateOrderStatus(status)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return Failure when the repository call is unsuccessful',
      () async {
        // Arrange
        const errorMessage = "No internet connection";
        provideDummy<Result<ActiveOrderDto>>(Failure(errorMessage));
        when(
          mockRepo.updateOrderStatus(status),
        ).thenAnswer((_) async => Failure(errorMessage));

        // Act
        final result = await useCase.call(status);

        // Assert
        expect(result, isA<Failure<ActiveOrderDto>>());
        expect((result as Failure).errorMessage, errorMessage);

        verify(mockRepo.updateOrderStatus(status)).called(1);
      },
    );
  });
}
