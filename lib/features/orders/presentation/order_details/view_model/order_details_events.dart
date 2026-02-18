class OrderDetailsEvents {}

class GetOrderNamesByIdsEvents extends OrderDetailsEvents {
  final List<String> ids;

  GetOrderNamesByIdsEvents({required this.ids});
}
