import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view/image_source_title.dart';

void main() {
  late bool tapped;

  Widget buildTestable(Widget child) {
    return AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(
        theme: LightTheme().themeData,
        home: Scaffold(body: child),
      ),
    );
  }

  setUp(() {
    tapped = false;
  });

  testWidgets('renders icon, title, and responds to tap', (tester) async {
    const testIcon = Icons.camera_alt;
    const testTitle = "Camera";

    await tester.pumpWidget(
      buildTestable(
        ImageSourceTile(
          icon: testIcon,
          title: testTitle,
          onTap: () => tapped = true,
        ),
      ),
    );

    /// Assert UI elements
    expect(find.text(testTitle), findsOneWidget);
    expect(find.byIcon(testIcon), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);

    /// Tap the tile
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    /// Assert callback fired
    expect(tapped, isTrue);
  });
}
