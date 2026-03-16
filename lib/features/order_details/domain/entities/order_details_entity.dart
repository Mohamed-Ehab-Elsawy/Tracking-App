class OrderDetailsEntity {
  String id, title, price;
  int count;

  OrderDetailsEntity(this.id, this.title, this.price, this.count);

  factory OrderDetailsEntity.fromMap(Map<String, dynamic> map) =>
      OrderDetailsEntity(
        map['orderId'] ?? '',
        map['title'] ?? '',
        map['totalPrice '] ?? '',
        map['count'] ?? 0,
      );
}
