import 'package:equatable/equatable.dart';

final class SectionsViewState extends Equatable {
  final int currentTab;

  const SectionsViewState({this.currentTab = 0});

  SectionsViewState copyWith({int? currentTab, int? selectedCategoryIndex}) =>
      SectionsViewState(currentTab: currentTab ?? this.currentTab);

  @override
  List<Object?> get props => [currentTab];
}

sealed class SectionsViewIntent {}

class ViewOrdersIntent extends SectionsViewIntent {}

class ViewHistoryIntent extends SectionsViewIntent {}

class ViewProfileIntent extends SectionsViewIntent {}
