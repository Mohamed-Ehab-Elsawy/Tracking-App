import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/orders/presentation/order_history/view/widgets/address_card.dart';

void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();
  late AddressCard addressCard;

  Widget  buildTestableWidgetWithData() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(home: addressCard),
      ),
    );
  }

  testWidgets('test AddressCard with null data', (WidgetTester tester) async {
    addressCard = AddressCard(imagePath: null, address: null, name: null);
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("unknown name".tr()), findsOneWidget);
    expect(find.text("unknown address".tr()), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
  });
  testWidgets('test AddressCard with real data', (WidgetTester tester) async {
    addressCard = AddressCard(imagePath: "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp", address: "giza", name: "abdo");
    await tester.pumpWidget(buildTestableWidgetWithData());
    expect(find.text("giza"), findsOneWidget);
    expect(find.text("abdo"), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
    expect(find.byType(CustomImageView), findsNWidgets(1));
  });

}