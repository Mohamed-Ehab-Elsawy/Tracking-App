import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_contracts.dart';

class SectionsCubit extends Cubit<SectionsViewState> {
  SectionsCubit() : super(SectionsViewState());

  void doIntent(SectionsViewIntent intent) {
    switch (intent) {
      case ViewOrdersIntent():
        _switchToOrders();

      case ViewHistoryIntent():
        _switchToHistory();

      case ViewProfileIntent():
        _switchToProfile();
    }
  }

  void _switchToOrders() => emit(state.copyWith(currentTab: 0));

  void _switchToHistory() => emit(state.copyWith(currentTab: 1));

  void _switchToProfile() => emit(state.copyWith(currentTab: 2));
}
