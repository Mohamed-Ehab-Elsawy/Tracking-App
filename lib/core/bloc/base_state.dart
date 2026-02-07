import 'package:equatable/equatable.dart' show EquatableMixin;

enum RequestState { init, loading, loaded, error }

/// Generic state for any async operation (API call, form submission, etc.)
class BaseState<T> with EquatableMixin {
  /// Current status of the operation
  final RequestState requestState;

  /// Error message if status is [RequestState.error]
  final String? errorMessage;

  /// Data if status is [RequestState.loaded]
  final T? data;
  const BaseState({required this.requestState, this.errorMessage, this.data});

  // ════════════════════════════════════════════
  // Factory constructors – one line each
  // ════════════════════════════════════════════
  factory BaseState.init() => const BaseState(
    requestState: RequestState.init,
  ); // Initial state (nothing happened yet)
  factory BaseState.loading([T? data]) => BaseState(
    requestState: RequestState.loading,
    data: data,
  ); // Operation in progress
  // Operation in progress
  factory BaseState.loaded(T? data) => BaseState(
    requestState: RequestState.loaded,
    data: data,
  ); // Success + data
  factory BaseState.error(String message) => BaseState(
    requestState: RequestState.error,
    errorMessage: message,
  ); // Failed

  // ════════════════════════════════════════════
  // Handy boolean getters
  // ════════════════════════════════════════════
  bool get isInitial =>
      requestState == RequestState.init; // Still in initial state
  bool get isLoading =>
      requestState == RequestState.loading; // Currently loading
  bool get isLoaded => requestState == RequestState.loaded; // Success with data
  bool get isError => requestState == RequestState.error;

  @override
  List<Object> get props {
    return [requestState, errorMessage ?? '', data ?? ''];
  } // Something went wrong
}

// ════════════════════════════════════════════
// Extension – makes emit() super clean
// ════════════════════════════════════════════
extension BaseStateExtension<T> on BaseState<T> {
  BaseState<T> get init => BaseState.init(); // Reset to Initial
  BaseState<T> get loading => BaseState.loading(); // Set Loading
  BaseState<T> loaded(T data) => BaseState.loaded(data); // Set Success
  BaseState<T> error(String message) => BaseState.error(message); // Set Error
}
