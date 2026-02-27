import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_contracts.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_cubit.dart';

void main() {
  group('SectionsCubit Tests', () {
    late SectionsCubit sectionsCubit;

    setUp(() => sectionsCubit = SectionsCubit());

    tearDown(() => sectionsCubit.close());

    test('initial state should have currentTab as 0', () {
      expect(sectionsCubit.state.currentTab, 0);
    });

    blocTest<SectionsCubit, SectionsViewState>(
      'emits state with currentTab: 0 when ViewOrdersIntent is added',
      build: () => sectionsCubit,
      act: (cubit) => cubit.doIntent(ViewOrdersIntent()),
      expect: () => [
        isA<SectionsViewState>().having((s) => s.currentTab, 'currentTab', 0),
      ],
    );

    blocTest<SectionsCubit, SectionsViewState>(
      'emits state with currentTab: 1 when ViewHistoryIntent is added',
      build: () => sectionsCubit,
      act: (cubit) => cubit.doIntent(ViewHistoryIntent()),
      expect: () => [
        isA<SectionsViewState>().having((s) => s.currentTab, 'currentTab', 1),
      ],
    );

    blocTest<SectionsCubit, SectionsViewState>(
      'emits state with currentTab: 2 when ViewProfileIntent is added',
      build: () => sectionsCubit,
      act: (cubit) => cubit.doIntent(ViewProfileIntent()),
      expect: () => [
        isA<SectionsViewState>().having((s) => s.currentTab, 'currentTab', 2),
      ],
    );
  });
}
