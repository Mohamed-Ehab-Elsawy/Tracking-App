import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/use_case/get_current_order_use_case.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';

import 'order_details_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetCurrentOrderUseCase>()])
void main() {
  late OrderDetailsCubit cubit;
  late MockGetCurrentOrderUseCase mockUseCase;

  final tOrderEntity = OrderEntity(id: "1", storeName: "Test Store");

  setUp(() {
    mockUseCase = MockGetCurrentOrderUseCase();
    cubit = OrderDetailsCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  group('OrderDetailsCubit Initial State', () {
    test('initial state is correct', () {
      expect(cubit.state.currentState.isInitial, isTrue);
      expect(cubit.state.currentStep, 0);
    });
  });

  group('GetOrderDetailsIntent', () {
    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'emits [Loading, Loaded] when use case returns Success',
      build: () {
        provideDummy<Result<OrderEntity>>(Success(tOrderEntity));
        when(mockUseCase.call()).thenAnswer((_) async => Success(tOrderEntity));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetOrderDetailsIntent()),
      expect: () => [
        predicate<OrderDetailsState>((s) => s.currentState.isLoading),

        predicate<OrderDetailsState>((s) {
          return s.currentState.isLoaded && s.currentState.data == tOrderEntity;
        }),
      ],
      verify: (_) => verify(mockUseCase.call()).called(1),
    );

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'emits [Loading, Error] when use case returns Failure',
      build: () {
        provideDummy<Result<OrderEntity>>(Failure("Server Error"));
        when(
          mockUseCase.call(),
        ).thenAnswer((_) async => Failure("Server Error"));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetOrderDetailsIntent()),
      expect: () => [
        predicate<OrderDetailsState>((s) => s.currentState.isLoading),
        predicate<OrderDetailsState>((s) {
          return s.currentState.isError &&
              s.currentState.errorMessage == "Server Error";
        }),
      ],
    );
  });

  group('ChangeStepIntent', () {
    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'increments currentStep by 1',
      build: () => cubit,
      act: (cubit) => cubit.doIntent(ChangeStepIntent()),
      expect: () => [predicate<OrderDetailsState>((s) => s.currentStep == 1)],
    );

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'resets currentStep to 0 when reaching step 5 (modulo 5)',
      build: () => cubit,
      seed: () => OrderDetailsState(BaseState.init(), currentStep: 4),
      act: (cubit) => cubit.doIntent(ChangeStepIntent()),
      expect: () => [predicate<OrderDetailsState>((s) => s.currentStep == 0)],
    );
  });
}
