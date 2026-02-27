import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/vehicle_info_card.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  late VehicleInfoCard vehicleInfoCard;

  Widget buildTestableWidgetWithData() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(home: vehicleInfoCard),
      ),
    );
  }

  testWidgets('test VehicleInfoCard with null data', (
    WidgetTester tester,
  ) async {
    vehicleInfoCard = VehicleInfoCard();
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("Vehicle info".tr()), findsOneWidget);
    expect(find.text("unknown Type".tr()), findsOneWidget);
    expect(find.text("unknown Number".tr()), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });
  testWidgets('test VehicleInfoCard with real data', (
    WidgetTester tester,
  ) async {
    vehicleInfoCard = VehicleInfoCard(
      vehicleNumber: "B B A 2144",
      vehicleType: "Isuzu",
    );
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("Vehicle info".tr()), findsOneWidget);
    expect(find.text("Isuzu"), findsOneWidget);
    expect(find.text("B B A 2144"), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });
  testWidgets("test onTap callback is triggered", (WidgetTester tester) async {
    bool tapped = false;

    vehicleInfoCard = VehicleInfoCard(
      onTap: () {
        tapped = true;
      },
    );

    await tester.pumpWidget(buildTestableWidgetWithData());

    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pump();

    expect(tapped, true);
  });
}
