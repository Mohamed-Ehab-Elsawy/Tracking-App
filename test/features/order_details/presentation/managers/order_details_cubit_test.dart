import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/use_case/get_current_order_use_case.dart';
import 'package:tracking_app/features/order_details/domain/use_case/update_order_status_use_case.dart';
import 'package:tracking_app/features/order_details/domain/use_case/save_notification_to_fire_base_use_case.dart';
import 'package:tracking_app/features/order_details/domain/use_case/send_notification_use_case.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import 'order_details_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UpdateOrderStatusUseCase>(),
  MockSpec<GetCurrentOrderUseCase>(),
  MockSpec<SaveNotificationToFireBaseUseCase>(),
  MockSpec<SendNotificationUseCase>(),
])
void main() {
  late CurrentOrderDetailsCubit cubit;
  late MockGetCurrentOrderUseCase mockGetCurrentOrderUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateUseCase;
  late MockSaveNotificationToFireBaseUseCase mockSaveNotificationUseCase;
  late MockSendNotificationUseCase mockSendNotificationUseCase;

  final tOrderEntity = OrderEntity(id: "1", storeName: "Test Store");

  setUp(() {
    mockGetCurrentOrderUseCase = MockGetCurrentOrderUseCase();
    mockUpdateUseCase = MockUpdateOrderStatusUseCase();
    mockUseCase = MockGetCurrentOrderUseCase();
    mockSaveNotificationUseCase = MockSaveNotificationToFireBaseUseCase();
    mockSendNotificationUseCase = MockSendNotificationUseCase();
    cubit = CurrentOrderDetailsCubit(
      mockGetCurrentOrderUseCase,
      mockUpdateUseCase,
      mockUseCase,
      mockSendNotificationUseCase,
      mockSaveNotificationUseCase,
    );

  });

  tearDown(() => cubit.close());

  group('OrderDetailsCubit Initial State', () {
    test('initial state is correct', () {
      expect(cubit.state.currentState.isInitial, isTrue);
      expect(cubit.state.currentStep, 0);
    });
  });

  group('GetOrderDetailsIntent', () {
    blocTest<CurrentOrderDetailsCubit, CurrentOrderDetailsState>(
      'emits [Loading, Loaded] when use case returns Success',
      build: () {
        provideDummy<Result<OrderEntity>>(Success(tOrderEntity));
        when(
          mockGetCurrentOrderUseCase.call(),
        ).thenAnswer((_) async => Success(tOrderEntity));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetCurrentOrderDetailsIntent()),
      expect: () => [
        predicate<CurrentOrderDetailsState>((s) => s.currentState.isLoading),

        predicate<CurrentOrderDetailsState>((s) {
          return s.currentState.isLoaded && s.currentState.data == tOrderEntity;
        }),
      ],
      verify: (_) => verify(mockGetCurrentOrderUseCase.call()).called(1),
    );

    blocTest<CurrentOrderDetailsCubit, CurrentOrderDetailsState>(
      'emits [Loading, Error] when use case returns Failure',
      build: () {
        provideDummy<Result<OrderEntity>>(Failure("Server Error"));
        when(
          mockGetCurrentOrderUseCase.call(),
        ).thenAnswer((_) async => Failure("Server Error"));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetCurrentOrderDetailsIntent()),
      expect: () => [
        predicate<CurrentOrderDetailsState>((s) => s.currentState.isLoading),
        predicate<CurrentOrderDetailsState>((s) {
          return s.currentState.isError &&
              s.currentState.errorMessage == "Server Error";
        }),
      ],
    );
  });

  group('ChangeStepIntent', () {
    final tOrder = OrderEntity(status: 'picked'); // Mock entity

    blocTest<CurrentOrderDetailsCubit, CurrentOrderDetailsState>(
      'increments currentStep by 1',
      build: () {
        // Stub the UseCase to return success
        when(
          mockUpdateUseCase.call(any),
        ).thenAnswer((_) async => Success(tOrder));
        return cubit;
      },
      build: () => cubit,
      act: (cubit) => cubit.doIntent(ChangeStepIntent()),
      expect: () => [
        predicate<CurrentOrderDetailsState>((s) => s.currentStep == 1),
      ],
    );

    blocTest<CurrentOrderDetailsCubit, CurrentOrderDetailsState>(
      'resets currentStep to 0 when reaching the end of OrderStatus',
      build: () {
        when(
          mockUpdateUseCase.call(any),
        ).thenAnswer((_) async => Success(tOrder));
        return cubit;
      },
      // Assuming OrderStatus.values.length is 5, step 4 + 1 % 5 = 0
      seed: () => CurrentOrderDetailsState(
        BaseState.init(),
        currentStep: OrderStatus.values.length - 1,
      ),
      act: (cubit) => cubit.doIntent(ChangeStepIntent()),
      expect: () => [
        predicate<CurrentOrderDetailsState>((s) => s.currentStep == 0),
      ],
    );
  });
}
