import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/orders/presentation/widgets/order_details_card.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();
  late OrderDetailsCard orderDetailsCard;

  Widget buildTestableWidgetWithData() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(home: orderDetailsCard),
      ),
    );
  }

  testWidgets('test orderDetailsCard with null data', (
    WidgetTester tester,
  ) async {
    orderDetailsCard = OrderDetailsCard(
      imagePath: null,
      quantity: null,
      name: null,
      price: null,
    );
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("un known name".tr()), findsOneWidget);
    expect(find.text("X0".tr()), findsOneWidget);
    expect(find.text("EGP 0"), findsOneWidget);
    expect(find.byType(CustomImageView), findsNWidgets(1));
  });
  testWidgets('test orderDetailsCard with real data', (
    WidgetTester tester,
  ) async {
    orderDetailsCard = OrderDetailsCard(
      imagePath:
          "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
      quantity: 1,
      name: "abdo",
      price: 1,
    );
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("abdo"), findsOneWidget);
    expect(find.text("X1"), findsOneWidget);
    expect(find.text("EGP 1"), findsOneWidget);
    expect(find.byType(CustomImageView), findsNWidgets(1));
  });
}
