import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_states.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/profile_view.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_states.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_contracts.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_cubit.dart';
import 'package:tracking_app/features/sections/presentation/sections_view.dart';

import 'sections_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SectionsCubit>(),
  MockSpec<ProfileViewModel>(),
  MockSpec<LogoutCubit>(),
  MockSpec<OrderHistoryCubit>(),
])
void main() {
  late MockSectionsCubit mockCubit;
  late MockProfileViewModel mockProfileViewModel;
  late MockLogoutCubit mockLogoutCubit;
  late MockOrderHistoryCubit mockOrderHistoryCubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    provideDummy<SectionsViewState>(const SectionsViewState());

    mockCubit = MockSectionsCubit();
    mockProfileViewModel = MockProfileViewModel();
    mockLogoutCubit = MockLogoutCubit();
    mockOrderHistoryCubit = MockOrderHistoryCubit();

    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockCubit.state).thenReturn(const SectionsViewState());

    when(mockProfileViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockProfileViewModel.state).thenReturn(ProfileStates());

    when(mockLogoutCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockLogoutCubit.state).thenReturn(LogoutDialogState());

    when(mockOrderHistoryCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockOrderHistoryCubit.state).thenReturn(OrderHistoryStates());
  });

  Widget buildTestableWidget() => EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SectionsCubit>.value(value: mockCubit),
            BlocProvider<ProfileViewModel>.value(value: mockProfileViewModel),
            BlocProvider<LogoutCubit>.value(value: mockLogoutCubit),
            BlocProvider<OrderHistoryCubit>.value(value: mockOrderHistoryCubit),
          ],
          child: const SectionsView(),
        ),
      ),
    ),
  );

  group('SectionsView Integration Tests with Mockito', () {
    testWidgets('renders Home page and triggers ViewHistoryIntent on tap', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(const SectionsViewState(currentTab: 0));

      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Home'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.fact_check_outlined));
      await tester.pump();

      verify(mockCubit.doIntent(argThat(isA<ViewHistoryIntent>()))).called(1);
    });

    testWidgets('renders Profile page when state is updated', (tester) async {
      when(mockCubit.state).thenReturn(const SectionsViewState(currentTab: 2));

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });
  });
}
