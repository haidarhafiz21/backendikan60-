class Order {
  final String orderId;
  final double totalAmount;
  final String? status;
  final String? createdAt;

  Order({
    required this.orderId,
    required this.totalAmount,
    this.status,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] ?? '',
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
