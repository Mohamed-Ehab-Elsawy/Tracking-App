import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_contracts.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_cubit.dart';
import 'package:tracking_app/features/sections/presentation/sections_view.dart';

import 'sections_view_test.mocks.dart';

@GenerateMocks([SectionsCubit])
void main() {
  late MockSectionsCubit mockCubit;

  setUp(() {
    provideDummy<SectionsViewState>(const SectionsViewState());
    mockCubit = MockSectionsCubit();
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestableWidget() => AppThemeProvider(
    appTheme: LightTheme(),
    child: MaterialApp(
      home: BlocProvider<SectionsCubit>.value(
        value: mockCubit,
        child: const SectionsView(),
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

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });
  });
}
