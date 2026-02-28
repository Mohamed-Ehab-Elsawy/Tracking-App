import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view/order_history_view.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_states.dart';
import 'package:tracking_app/features/orders/presentation/widgets/order_card.dart';
import 'package:tracking_app/features/orders/presentation/widgets/orders_number_card.dart';

import 'order_history_view_test.mocks.dart';

@GenerateMocks([OrderHistoryCubit])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  late MockOrderHistoryCubit cubit;
  late OrdersListEntity orderEntity1;
  late OrdersListEntity orderEntity2;
  late OrderHistoryView view;

  late List<OrdersListEntity> list;
  setUpAll(() async {
    await EasyLocalization.ensureInitialized();
  });
  setUp(() {
    cubit = MockOrderHistoryCubit();
    orderEntity1 = OrdersListEntity(
      id: "10",
      driver: "10",
      order: OrderDto(state: "canceled", orderNumber: "10"),
      v: 10,
      createdAt: "10",
      updatedAt: "10",
      store: Store(
        name: "elevate",
        image:
            "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
        address: "10",
      ),
    );
    orderEntity2 = OrdersListEntity(
      id: "10",
      driver: "10",
      order: OrderDto(state: "completed", orderNumber: "10"),
      v: 10,
      createdAt: "10",
      updatedAt: "10",
      store: Store(
        name: "elevate",
        image:
            "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
        address: "10",
      ),
    );
    list = [orderEntity1, orderEntity2];

    provideDummy<Result<List<OrdersListEntity>>>(
      Success<List<OrdersListEntity>>(list),
    );
    view = OrderHistoryView();
    when(cubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      cubit.state,
    ).thenReturn(OrderHistoryStates(ordersList: BaseState.loading()));

    when(cubit.doIntent(any)).thenAnswer((_) async {});

    when(cubit.doEvent(any)).thenReturn(null);

    when(cubit.orderHistoryUiEvent).thenAnswer((_) => const Stream.empty());
  });
  Widget buildTestableWidget() {
    return EasyLocalization(
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(
          home: BlocProvider<OrderHistoryCubit>(
            create: (_) => cubit,
            child: view,
          ),
        ),
      ),
    );
  }

  testWidgets("test loading state", (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Orders"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets("test loaded state with null data", (WidgetTester tester) async {
    when(cubit.state).thenReturn(
      OrderHistoryStates(
        ordersList: BaseState<List<OrdersListEntity>>(
          requestState: RequestState.loaded,
          data: [],
        ),
      ),
    );
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("No Order Yet"), findsOneWidget);
  });
  testWidgets("test loaded state with  data", (WidgetTester tester) async {
    when(cubit.state).thenReturn(
      OrderHistoryStates(
        ordersList: BaseState<List<OrdersListEntity>>(
          requestState: RequestState.loaded,
          data: list,
        ),
      ),
    );
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    expect(find.byType(OrdersNumberCard), findsNWidgets(2));
    expect(find.text("canceled"), findsNWidgets(2));
    expect(find.text("completed"), findsNWidgets(2));
    expect(find.text(" Recent orders : "), findsOneWidget);
    expect(find.byType(OrderCard), findsNWidgets(2));
  });
  testWidgets("test error state ", (WidgetTester tester) async {
    when(cubit.state).thenReturn(
      OrderHistoryStates(
        ordersList: BaseState<List<OrdersListEntity>>(
          requestState: RequestState.error,
          errorMessage: "something went wrong",
        ),
      ),
    );
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.text("something went wrong"), findsOneWidget);
  });
}
