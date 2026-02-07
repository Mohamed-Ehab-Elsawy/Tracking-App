import 'dart:ui';

import 'package:equatable/equatable.dart';

class AppDialogAction with EquatableMixin {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  // coverage:ignore-line
  const AppDialogAction._({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  factory AppDialogAction.primary({
    required String label,
    required VoidCallback onPressed,
  }) => AppDialogAction._(label: label, onPressed: onPressed, isPrimary: true);

  factory AppDialogAction.outlined({
    required String label,
    required VoidCallback onPressed,
  }) => AppDialogAction._(label: label, onPressed: onPressed, isPrimary: false);

  @override
  List<Object?> get props => [label, onPressed, isPrimary];
}
