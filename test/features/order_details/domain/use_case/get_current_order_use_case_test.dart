import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repo.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';
import 'package:tracking_app/features/order_details/domain/use_case/get_current_order_use_case.dart';

import 'get_current_order_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OrderDetailsRepository>()])
void main() {
  late GetCurrentOrderUseCase useCase;
  late MockOrderDetailsRepository mockRepo;

  setUp(() {
    mockRepo = MockOrderDetailsRepository();
    useCase = GetCurrentOrderUseCase(mockRepo);
  });

  final tOrderEntity = OrderEntity(
    id: "123",
    storeName: "Senior Flutter Store",
  );

  group('GetCurrentOrderUseCase Tests', () {
    test(
      'should call getCurrentOrderDetails from repository and return Success',
      () async {
        // Arrange
        provideDummy<Result<OrderEntity>>(Success(tOrderEntity));
        when(
          mockRepo.getCurrentOrderDetails(),
        ).thenAnswer((_) async => Success(tOrderEntity));

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<Success<OrderEntity>>());
        expect((result as Success).data, tOrderEntity);

        // Verify the repository was called exactly once
        verify(mockRepo.getCurrentOrderDetails()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'should return Failure when the repository call is unsuccessful',
      () async {
        // Arrange
        const errorMessage = "No internet connection";
        provideDummy<Result<OrderEntity>>(Failure(errorMessage));
        when(
          mockRepo.getCurrentOrderDetails(),
        ).thenAnswer((_) async => Failure(errorMessage));

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, isA<Failure<OrderEntity>>());
        expect((result as Failure).errorMessage, errorMessage);

        verify(mockRepo.getCurrentOrderDetails()).called(1);
      },
    );
  });
}
