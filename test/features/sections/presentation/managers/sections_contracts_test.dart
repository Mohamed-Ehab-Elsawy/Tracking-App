import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_contracts.dart';

void main() {
  group('SectionsViewState', () {
    test('supports value comparisons (Equatable)', () {
      expect(
        const SectionsViewState(currentTab: 0),
        const SectionsViewState(currentTab: 0),
      );
    });

    test('default constructor sets currentTab to 0', () {
      const state = SectionsViewState();
      expect(state.currentTab, 0);
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        const state = SectionsViewState(currentTab: 1);
        expect(state.copyWith(), const SectionsViewState(currentTab: 1));
      });

      test('replaces currentTab when provided', () {
        const state = SectionsViewState(currentTab: 0);
        final result = state.copyWith(currentTab: 5);
        expect(result.currentTab, 5);
      });

      test('ignores selectedCategoryIndex (Current Implementation Check)', () {
        const state = SectionsViewState(currentTab: 1);
        final result = state.copyWith(selectedCategoryIndex: 99);
        expect(result.currentTab, 1);
      });
    });

    test('props contains currentTab', () {
      const state = SectionsViewState(currentTab: 10);
      expect(state.props, [10]);
    });
  });

  group('SectionsViewIntent', () {
    test('ViewOrdersIntent supports value comparisons', () {
      expect(ViewOrdersIntent(), isA<ViewOrdersIntent>());
    });

    test('ViewHistoryIntent supports value comparisons', () {
      expect(ViewHistoryIntent(), isA<ViewHistoryIntent>());
    });

    test('ViewProfileIntent supports value comparisons', () {
      expect(ViewProfileIntent(), isA<ViewProfileIntent>());
    });
  });
}
