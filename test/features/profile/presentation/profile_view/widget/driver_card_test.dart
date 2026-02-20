import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/driver_card.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();
  late DriverCard driverCard;

  Widget buildTestableWidgetWithData() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(home: driverCard),
      ),
    );
  }

  testWidgets('test driverCard with null data', (WidgetTester tester) async {
    driverCard = DriverCard();
    await tester.pumpWidget(buildTestableWidgetWithData());
    //  expect(find.text("unknown name".tr()), findsOneWidget);
    expect(find.text("unknown email".tr()), findsOneWidget);
    expect(find.text("unknown phone".tr()), findsOneWidget);
    expect(find.byType(CustomImageView), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });
  testWidgets('test driverCard with real data', (WidgetTester tester) async {
    driverCard = DriverCard(
      firstName: "abdo",
      lastName: "salah",
      email: "abdo@gmail.com",
      phone: "01000000000",
      photo:
          "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
    );
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("abdo salah".tr()), findsOneWidget);
    expect(find.text("abdo@gmail.com"), findsOneWidget);
    expect(find.text("01000000000"), findsOneWidget);
    expect(find.byType(CustomImageView), findsNWidgets(1));
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });
  testWidgets("test onTap callback is triggered", (WidgetTester tester) async {
    bool tapped = false;

    driverCard = DriverCard(
      onTap: () {
        tapped = true;
      },
      photo:
          "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
    );

    await tester.pumpWidget(buildTestableWidgetWithData());

    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pump();

    expect(tapped, true);
  });
}
