import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/orders/presentation/widgets/orders_number_card.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();
  late OrdersNumberCard ordersNumberCard;

  Widget buildTestableWidgetWithData() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(home: ordersNumberCard),
      ),
    );
  }

  testWidgets('test OrdersNumberCard with null data', (
    WidgetTester tester,
  ) async {
    ordersNumberCard = OrdersNumberCard(state: null, number: null);
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("un know state".tr()), findsOneWidget);
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
  });
  testWidgets('test OrdersNumberCard with completed state', (
    WidgetTester tester,
  ) async {
    ordersNumberCard = OrdersNumberCard(state: "completed", number: 2);
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("completed"), findsOneWidget);
    expect(find.text("2"), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });
  testWidgets('test OrdersNumberCard with canceled state', (
    WidgetTester tester,
  ) async {
    ordersNumberCard = OrdersNumberCard(state: "canceled", number: 2);
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("canceled"), findsOneWidget);
    expect(find.text("2"), findsOneWidget);
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
  });
}
