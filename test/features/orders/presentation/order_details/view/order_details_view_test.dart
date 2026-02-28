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
import 'package:tracking_app/features/orders/domain/entity/product_entity.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view/order_details_view.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_events.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_states.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/widgets/address_card.dart';
import 'package:tracking_app/features/orders/presentation/widgets/order_details_card.dart';
import 'order_details_view_test.mocks.dart';

@GenerateMocks([OrderItemNameCubit])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  late MockOrderItemNameCubit cubit;
  late OrdersListEntity orderEntity;
  late ProductEntity productEntity;

  setUpAll(() async {
    await EasyLocalization.ensureInitialized();
  });
  setUp(() {
    cubit = MockOrderItemNameCubit();
    orderEntity = OrdersListEntity(
      id: "10",
      driver: "10",
      order: OrderDto(
        totalPrice: 100,
        state: "canceled",
        orderNumber: "11445",
        paymentType: "cash",
        orderItems: [
          OrderItems(
            id: "10",
            price: 10,
            quantity: 1,
            product: Product(id: "10", price: 100),
          ),
        ],
      ),
      store: Store(
        name: "elevate",
        image:
            "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
        address: "10",
      ),
    );
    productEntity = ProductEntity(
      id: "10",
      title: "title",
      slug: "slug",
      description: "description",
      imgCover: "imgCover",
      images: [
        "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
        "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
      ],
      price: 10,
      priceAfterDiscount: 10,
    );

    provideDummy<Result<Map<String, ProductEntity>>>(
      Success<Map<String, ProductEntity>>({"10": productEntity}),
    );

    when(cubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      cubit.state,
    ).thenReturn(OrderDetailsStates(orderNames: BaseState.loading()));

    when(cubit.doIntent(any)).thenAnswer((_) async {});
  });
  Widget buildTestableWidget() {
    return EasyLocalization(
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(
          home: BlocProvider<OrderItemNameCubit>(
            create: (_) => cubit,
            child: Builder(
              builder: (context) {
                return Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) => const OrderDetailsView(),
                    settings: RouteSettings(arguments: orderEntity),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  testWidgets("test loading state", (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Order details"), findsOneWidget);
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    expect(find.text("canceled"), findsOneWidget);
    expect(find.text("11445"), findsOneWidget);
    expect(find.text(" Pickup address : "), findsOneWidget);
    expect(find.text(" User address : "), findsOneWidget);
    expect(find.byType(AddressCard), findsNWidgets(2));
    expect(find.text(" Order details : "), findsOneWidget);
    expect(find.text("Total : "), findsOneWidget);
    expect(find.text("100 EGP"), findsOneWidget);
    expect(find.text("Payment method : "), findsOneWidget);
    expect(find.text("cash"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets("test loading loaded state with null data", (
    WidgetTester tester,
  ) async {
    when(cubit.state).thenReturn(
      OrderDetailsStates(
        orderNames: BaseState<Map<String, ProductEntity>>(
          requestState: RequestState.loaded,
          data: null,
        ),
      ),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    verify(cubit.doIntent(GetOrderNamesByIdsEvents(ids: ["10"]))).called(1);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Order details"), findsOneWidget);
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    expect(find.text("canceled"), findsOneWidget);
    expect(find.text("11445"), findsOneWidget);
    expect(find.text(" Pickup address : "), findsOneWidget);
    expect(find.text(" User address : "), findsOneWidget);
    expect(find.byType(AddressCard), findsNWidgets(2));
    expect(find.text(" Order details : "), findsOneWidget);
    expect(find.text("Total : "), findsOneWidget);
    expect(find.text("100 EGP"), findsOneWidget);
    expect(find.text("Payment method : "), findsOneWidget);
    expect(find.text("cash"), findsOneWidget);
    expect(find.byType(OrderDetailsCard), findsNWidgets(1));
  });
  testWidgets("test loading loaded state with  data", (
    WidgetTester tester,
  ) async {
    when(cubit.state).thenReturn(
      OrderDetailsStates(
        orderNames: BaseState<Map<String, ProductEntity>>(
          requestState: RequestState.loaded,
          data: {"10": productEntity},
        ),
      ),
    );
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    verify(cubit.doIntent(GetOrderNamesByIdsEvents(ids: ["10"]))).called(1);

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Order details"), findsOneWidget);
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    expect(find.text("canceled"), findsOneWidget);
    expect(find.text("11445"), findsOneWidget);
    expect(find.text(" Pickup address : "), findsOneWidget);
    expect(find.text(" User address : "), findsOneWidget);
    expect(find.byType(AddressCard), findsNWidgets(2));
    expect(find.text(" Order details : "), findsOneWidget);
    expect(find.text("Total : "), findsOneWidget);
    expect(find.text("100 EGP"), findsOneWidget);
    expect(find.text("Payment method : "), findsOneWidget);
    expect(find.text("cash"), findsOneWidget);
    expect(find.byType(OrderDetailsCard), findsNWidgets(1));
  });
}
