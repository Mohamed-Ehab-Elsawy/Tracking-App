class OrderDetailsEntity {
  String id, title, price;
  int count;

  OrderDetailsEntity(this.id, this.title, this.price, this.count);

  factory OrderDetailsEntity.fromMap(Map<String, dynamic> map) =>
      OrderDetailsEntity(
        map['id'] ?? '',
        map['title'] ?? '',
        map['price'] ?? '',
        map['count'] ?? 0,
      );
}
