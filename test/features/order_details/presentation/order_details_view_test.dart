import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';
import 'package:tracking_app/features/order_details/presentation/order_details_view.dart';
import 'package:tracking_app/features/order_details/presentation/widgets/order_status_card.dart';

import 'order_details_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CurrentOrderDetailsCubit>()])
void main() {
  late MockCurrentOrderDetailsCubit mockCubit;
  // late CurrentOrderDetailsState mockState;

  final mockEntity = OrderEntity(
    storeName: "Test Store",
    storeAddress: "123 Store St",
    storePhone: "1234567890",
    userName: "John Doe",
    userAddress: "456 User Ave",
    userPhone: "0987654321",
    details: [
      OrderDetailsEntity("1", "Burger", "150", 2),
      OrderDetailsEntity("2", "Fries", "50", 1),
    ],
  );

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockCubit = MockCurrentOrderDetailsCubit();
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Future<void> pumpOrderDetailsView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        child: AppThemeProvider(
          appTheme: LightTheme(),
          child: MaterialApp(
            home: BlocProvider<CurrentOrderDetailsCubit>.value(
              value: mockCubit,
              child: const CurrentOrderDetailsView(),
            ),
          ),
        ),
      ),
    );
  }

  group('OrderDetailsView Tests', () {
    testWidgets('renders Skeletonizer and fake cards when state is Loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockCubit.state).thenReturn(
        CurrentOrderDetailsState(
          BaseState.loading(),
          sendNotificationState: BaseState.init(),
          notificationState: BaseState.init(),
        ),
      );

      // Act
      await pumpOrderDetailsView(tester);

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text("Status : Accepted"), findsOneWidget);
    });

    testWidgets('renders error message when state is Error', (
      WidgetTester tester,
    ) async {
      // Arrange
      const errorMessage = "Something went wrong!";
      when(mockCubit.state).thenReturn(
        CurrentOrderDetailsState(
          BaseState.error(errorMessage),
          sendNotificationState: BaseState.init(),
          notificationState: BaseState.init(),
        ),
      );

      // Act
      await pumpOrderDetailsView(tester);

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets(
      'renders Order Details data successfully when state is Loaded',
      (WidgetTester tester) async {
        // Arrange
        when(mockCubit.state).thenReturn(
          CurrentOrderDetailsState(
            BaseState.loaded(mockEntity),
            currentStep: 2,
            notificationState: BaseState.init(),
            sendNotificationState: BaseState.init(),
          ),
        );

        // Act
        await pumpOrderDetailsView(tester);

        // Assert
        expect(find.byType(CurrentOrderStatusCard), findsOneWidget);

        expect(find.text("Test Store"), findsOneWidget);
        expect(find.text("John Doe"), findsOneWidget);

        expect(find.text("Burger"), findsOneWidget);
        expect(find.text("Fries"), findsOneWidget);
      },
    );

    testWidgets('fires ChangeStepIntent when Next Step button is clicked', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockCubit.state).thenReturn(
        CurrentOrderDetailsState(
          BaseState.loaded(mockEntity),
          sendNotificationState: BaseState.init(),
          notificationState: BaseState.init(),
        ),
      );

      // Act
      await pumpOrderDetailsView(tester);

      final buttonFinder = find.byKey(const Key('next_step_button'));

      await tester.tap(buttonFinder);
      await tester.pump();

      // Assert
      verify(mockCubit.doIntent(argThat(isA<ChangeStepIntent>()))).called(1);
    });

    testWidgets('renders SizedBox.shrink when state is Initial', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockCubit.state).thenReturn(CurrentOrderDetailsState.initial());

      // Act
      await pumpOrderDetailsView(tester);

      // Assert
      expect(find.byType(Skeletonizer), findsNothing);
      expect(find.byType(CurrentOrderStatusCard), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
    });
  });
}
