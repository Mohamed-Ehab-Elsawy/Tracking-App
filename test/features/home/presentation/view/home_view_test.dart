import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/app_error_view.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_state.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';
import 'package:tracking_app/features/home/presentation/view/home_view.dart';
import 'package:tracking_app/features/home/presentation/widgets/order_card.dart';
import 'package:tracking_app/features/home/presentation/widgets/order_card_loading.dart';
import 'package:tracking_app/features/home/presentation/widgets/order_list.dart';

import 'home_view_test.mocks.dart';

@GenerateMocks([OrdersViewModel])
void main() {
  late MockOrdersViewModel mockViewModel;
  late StreamController<OrdersEvent> eventController;
  late StreamController<OrdersState> stateController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockViewModel = MockOrdersViewModel();
    eventController = StreamController<OrdersEvent>.broadcast();
    stateController = StreamController<OrdersState>.broadcast();

    when(mockViewModel.eventStream).thenAnswer((_) => eventController.stream);
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);
    when(
      mockViewModel.state,
    ).thenReturn(OrdersState(ordersState: BaseState.init()));
    when(mockViewModel.close()).thenAnswer((_) async => {});
  });
  tearDown(() {
    eventController.close();
    stateController.close();
  });
  Widget makeTestableWidget() {
    return AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(
        home: BlocProvider<OrdersViewModel>(
          create: (context) => mockViewModel,
          child: const HomeView(),
        ),
      ),
    );
  }

  group('home view test widget', () {
    testWidgets('home view test loading case', (tester) async {
      when(
        mockViewModel.state,
      ).thenReturn(OrdersState(ordersState: BaseState.loading()));
      await tester.pumpWidget(makeTestableWidget());
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('floweryRider'), findsOneWidget);
      expect(find.byType(OrderCardLoading), findsOneWidget);
    });
    testWidgets('home view test error case', (tester) async {
      final errorMsg = 'error';
      when(
        mockViewModel.state,
      ).thenReturn(OrdersState(ordersState: BaseState.error(errorMsg)));
      await tester.pumpWidget(makeTestableWidget());
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('floweryRider'), findsOneWidget);
      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text(errorMsg), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('retry'), findsOneWidget);
      expect(find.byType(OrderCardLoading), findsNothing);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      verify(mockViewModel.doIntent(argThat(isA<GetOrdersIntent>()))).called(1);
    });

    testWidgets('home view test loaded case', (tester) async {
      final String testImageUrl = 'https://www.elevateegy.com/elevate.png';
      final mockOrders = HomeOrderEntity(
        orderId: '1',
        userName: 'abdo',
        status: 'pending',
        storeName: 'elevate',
        storeAddress: 'cairo store',
        storeImage: testImageUrl,
        totalPrice: 100.0,
        userImage: testImageUrl,
        userAddress: 'cairo user',
      );
      when(mockViewModel.state).thenReturn(
        OrdersState(
          ordersState: BaseState.loaded([mockOrders]),
          orders: BaseState.loaded([mockOrders]),
          order: BaseState.loaded(mockOrders),
        ),
      );

      await tester.pumpWidget(makeTestableWidget());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(OrderList), findsOneWidget);
      expect(find.byType(OrderCard), findsOneWidget);

      final imageFinder = find.byType(CustomImageView);

      expect(imageFinder, findsAtLeastNWidgets(2));

      final CustomImageView firstImage = tester.widget(imageFinder.at(0));
      expect(firstImage.imagePath, equals(testImageUrl));
      final CustomImageView userImageWidget = tester.widget(imageFinder.at(1));
      expect(userImageWidget.imagePath, equals(testImageUrl));
      expect(find.text('abdo'), findsOneWidget);
      expect(find.text('elevate'), findsOneWidget);
      expect(find.text('cairo store'), findsOneWidget);
      expect(find.text('cairo user'), findsOneWidget);
      expect(find.textContaining('100.0'), findsOneWidget);

      expect(find.text('flowerOrder'), findsOneWidget);
      expect(find.text('pickupAddress'), findsOneWidget);
      expect(find.text('userAddress'), findsOneWidget);

      final rejectButton = find.widgetWithText(OutlinedButton, 'reject');
      expect(rejectButton, findsOneWidget);

      await tester.tap(rejectButton);
      await tester.pump();

      verify(
        mockViewModel.doIntent(
          argThat(
            isA<RejectOrderIntent>().having((i) => i.orderId, 'orderId', '1'),
          ),
        ),
      ).called(1);
    });
  });
}
