import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';

class OrderHistoryEvents {}

class GetOrdersHistoryEvents extends OrderHistoryEvents {
  final List<OrdersListEntity>? ordersList;

  GetOrdersHistoryEvents({this.ordersList});
}

class OrderHistoryUiEvents {}

class NavigateToOrderDetails extends OrderHistoryUiEvents {
  final OrdersListEntity order;
  NavigateToOrderDetails({required this.order});
}
