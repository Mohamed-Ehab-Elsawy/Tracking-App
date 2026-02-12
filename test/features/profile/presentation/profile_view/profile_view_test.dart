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
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/profile_view.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/driver_card.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/main_profile_item.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/vehicle_info_card.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_states.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';
import 'profile_view_test.mocks.dart';

@GenerateMocks([ProfileViewModel])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  await EasyLocalization.ensureInitialized();

  late MockProfileViewModel cubit;
  late DriverEntity entity;

  setUp(() {
    cubit = MockProfileViewModel();
    entity = DriverEntity(
      firstName: "abdo",
      lastName: "salah",
      phone: "01000000000",
      email: "james.buchanan@examplepetstore.com",
      vehicleType: "car",
      vehicleNumber: "123456",
      photo:
          "https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp",
    );

    provideDummy<Result<DriverEntity>>(Success<DriverEntity>(entity));
    when(cubit.stream).thenAnswer((_) => const Stream.empty());
    when(cubit.doIntent(any)).thenReturn(null);
    when(cubit.uiEvents).thenAnswer((_) => const Stream.empty());
  });
  Widget buildTestableWidget() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: AppThemeProvider(
        appTheme: LightTheme(),
        child: MaterialApp(
          home: BlocProvider<ProfileViewModel>.value(
            value: cubit,
            child: const ProfileView(),
          ),
        ),
      ),
    );
  }

  testWidgets('test loading state', (WidgetTester tester) async {
    //arrange
    when(cubit.state).thenReturn(
      const ProfileStates(
        driverData: BaseState(requestState: RequestState.loading),
      ),
    );
    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(CircularProgressIndicator), findsNWidgets(1));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Profile"), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_sharp), findsOneWidget);
    expect(find.byType(MainProfileItem), findsNWidgets(2));
  });
  testWidgets('test loaded state', (WidgetTester tester) async {
    when(cubit.state).thenReturn(
      ProfileStates(
        driverData: BaseState(requestState: RequestState.loaded, data: entity),
      ),
    );
    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Profile"), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_sharp), findsOneWidget);
    expect(find.byType(DriverCard), findsOneWidget);
    expect(find.byType(VehicleInfoCard), findsOneWidget);
    expect(find.text("language"), findsOneWidget);
    expect(find.text("logout"), findsOneWidget);
    expect(find.byType(MainProfileItem), findsNWidgets(2));
  });
  testWidgets('test error state with error message', (
    WidgetTester tester,
  ) async {
    when(cubit.state).thenReturn(
      ProfileStates(
        driverData: BaseState(
          requestState: RequestState.error,
          errorMessage: "error",
        ),
      ),
    );
    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Profile"), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_sharp), findsOneWidget);
    expect(find.text("error"), findsOneWidget);
    expect(find.text("language"), findsOneWidget);
    expect(find.text("logout"), findsOneWidget);
  });
  testWidgets('test error state without error message', (
    WidgetTester tester,
  ) async {
    when(cubit.state).thenReturn(
      ProfileStates(driverData: BaseState(requestState: RequestState.error)),
    );
    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Profile"), findsOneWidget);

    expect(find.byIcon(Icons.notifications_none_sharp), findsOneWidget);
    expect(find.text("language"), findsOneWidget);
    expect(find.text("logout"), findsOneWidget);
    expect(find.text("something went wrong"), findsOneWidget);
  });
  // testWidgets('test on language click', (WidgetTester tester) async {
  //   when(cubit.state).thenReturn(
  //     ProfileStates(
  //       driverData: BaseState(requestState: RequestState.loaded, data: entity),
  //     ),
  //   );
  //
  //   await tester.pumpWidget(buildTestableWidget());
  //   await tester.pumpAndSettle();
  //
  //   final languageItemFinder = find.byWidgetPredicate(
  //         (widget) => widget is MainProfileItem && widget.title == 'language',
  //   );
  //   expect(languageItemFinder, findsOneWidget);
  //
  //
  //   await tester.tap(languageItemFinder);
  //   await tester.pump();
  //   await tester.pump(const Duration(seconds: 1));
  //
  //
  //   expect(find.byType(BottomSheet), findsOneWidget);
  //   expect(find.byType(LanguageBottomSheet), findsOneWidget);
  // });

  // testWidgets('test on logout click', (WidgetTester tester) async {
  //   when(cubit.state).thenReturn(
  //     ProfileStates(
  //       driverData: BaseState(requestState: RequestState.loaded, data: entity),
  //     ),
  //   );
  //   await tester.pumpWidget(buildTestableWidget());
  //   await tester.pump();
  //   await tester.pump(const Duration(seconds: 1));
  //   final logoutItemFinder = find.byWidgetPredicate(
  //         (widget) =>
  //     widget is MainProfileItem &&
  //         widget.title == 'logout',
  //   );
  //   expect(logoutItemFinder, findsOneWidget);
  //
  //   await tester.tap(logoutItemFinder);
  //   await tester.pump();
  //   await tester.pump(const Duration(seconds: 1));
  //
  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text("Are you sure you want to logout?"), findsOneWidget);
  //   expect(find.text("Yes"), findsOneWidget);
  //   expect(find.text("No"), findsOneWidget);
  //
  //   await tester.tap(find.text("Yes"));
  //   await tester.pumpAndSettle();
  // });
  // testWidgets('test on profile click', (WidgetTester tester) async {
  //   when(cubit.state).thenReturn(
  //     ProfileStates(
  //       driverData: BaseState(requestState: RequestState.loaded, data: entity),
  //     ),
  //   );
  //
  //   await tester.pumpWidget(buildTestableWidget());
  //   await tester.pumpAndSettle();
  //
  //   final driverCardFinder = find.byType(DriverCard);
  //   expect(driverCardFinder, findsOneWidget);
  //
  //   await tester.tap(driverCardFinder);
  //   await tester.pumpAndSettle();
  //   verify(cubit.doEvent(argThat(isA<OnProfileClickIntent>()))).called(1);
  // });

  // testWidgets('test on vehicle info click', (WidgetTester tester) async {
  //   when(cubit.state).thenReturn(
  //     ProfileStates(
  //       driverData: BaseState(requestState: RequestState.loaded, data: entity),
  //     ),
  //   );
  //
  //   await tester.pumpWidget(buildTestableWidget());
  //   await tester.pumpAndSettle();
  //
  //   final vehicleInfoCardFinder = find.byType(VehicleInfoCard);
  //   expect(vehicleInfoCardFinder, findsOneWidget);
  //
  //   await tester.tap(vehicleInfoCardFinder);
  //   await tester.pumpAndSettle();
  //   verify(cubit.doEvent(argThat(isA<OnVehicleInfoClickIntent>()))).called(1);
  // });

  // testWidgets('test on notification click', (WidgetTester tester) async {
  //
  // });
}
