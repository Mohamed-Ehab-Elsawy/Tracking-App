import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/orders/presentation/order_history/view/widgets/address_card.dart';
import 'package:tracking_app/features/orders/presentation/order_history/view/widgets/order_card.dart';

void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();
  late OrderCard orderCard;

  Widget  buildTestableWidgetWithData() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(home: orderCard),
      ),
    );
  }

  testWidgets('test OrdersCard with null data', (WidgetTester tester) async {
    orderCard = OrderCard(orderNumber: null, status: null, shopImagePath: null, shopAddress: null, shopName: null, userImagePath: null, userAddress: null, userName: null);
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("Flower order".tr()), findsOneWidget);
    expect(find.text("un know state".tr()), findsOneWidget);
    expect(find.text("un know number".tr()), findsOneWidget);
    expect(find.text("Pickup address".tr()), findsOneWidget);
    expect(find.text("User address".tr()), findsOneWidget);
    expect(find.byType(AddressCard),findsNWidgets(2) );
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    expect(find.byType(CustomImageView),findsNWidgets(2) );

  });
  testWidgets('test OrdersCard with completed state', (WidgetTester tester) async {
    orderCard = OrderCard(orderNumber: "123456", status: "completed", shopImagePath: "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp", shopAddress: "giza", shopName: "abdo", userImagePath: "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp", userAddress: "zag", userName: "aly");
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("Flower order".tr()), findsOneWidget);
    expect(find.text("completed"), findsOneWidget);
    expect(find.text("123456"), findsOneWidget);
    expect(find.text("aly"), findsOneWidget);
    expect(find.text("zag"), findsOneWidget);
    expect(find.text("giza"), findsOneWidget);
    expect(find.text("abdo"), findsOneWidget);
    expect(find.byType(AddressCard),findsNWidgets(2) );
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.byType(CustomImageView),findsNWidgets(2) );

  });
  testWidgets('test OrdersCard with canceled state', (WidgetTester tester) async {
    orderCard = OrderCard(orderNumber: "123456", status: "canceled", shopImagePath: "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp", shopAddress: "giza", shopName: "abdo", userImagePath: "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp", userAddress: "zag", userName: "aly");
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("Flower order".tr()), findsOneWidget);
    expect(find.text("canceled"), findsOneWidget);
    expect(find.text("123456"), findsOneWidget);
    expect(find.text("aly"), findsOneWidget);
    expect(find.text("zag"), findsOneWidget);
    expect(find.text("giza"), findsOneWidget);
    expect(find.text("abdo"), findsOneWidget);
    expect(find.byType(AddressCard),findsNWidgets(2) );
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    expect(find.byType(CustomImageView),findsNWidgets(2) );

  });


}