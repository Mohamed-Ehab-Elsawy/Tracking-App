import 'package:equatable/equatable.dart';

sealed class OrdersIntent {}

class GetOrdersIntent extends OrdersIntent {
  final bool refresh;

  GetOrdersIntent({this.refresh = false});
}

class RefreshOrdersIntent extends OrdersIntent {}

class LoadMoreOrdersIntent extends OrdersIntent {}

class RejectOrderIntent extends OrdersIntent with EquatableMixin {
  final String orderId;
  RejectOrderIntent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class AcceptOrderIntent extends OrdersIntent with EquatableMixin {
  final String orderId;
  AcceptOrderIntent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

sealed class OrdersEvent {}

class RejectOrderEvent extends OrdersEvent with EquatableMixin {
  final String orderId;
  RejectOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class AcceptOrderEvent extends OrdersEvent with EquatableMixin {
  final String orderId;
  AcceptOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class NavigateToOrderDetailsEvent extends OrdersEvent with EquatableMixin {
  final String orderId;
  NavigateToOrderDetailsEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ShowSnackBarEvent extends OrdersEvent {
  final String message;
  final bool isError;
  ShowSnackBarEvent({required this.message, required this.isError});
}
