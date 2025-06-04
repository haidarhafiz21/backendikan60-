class TransactionDetails {
  final String orderId;
  final double amount;
  final String? productId;
  final List<Map<String, dynamic>> itemDetails;

  TransactionDetails({
    required this.orderId,
    required this.amount,
    this.productId,
    List<Map<String, dynamic>>? itemDetails,
  }) : itemDetails = itemDetails ?? [];

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      orderId: json['orderId'],
      amount: (json['amount'] as num).toDouble(),
      productId: json['productId'],
      itemDetails: json['itemDetails'] != null
          ? List<Map<String, dynamic>>.from(
              (json['itemDetails'] as List).map((item) => Map<String, dynamic>.from(item)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'productId': productId,
      'itemDetails': itemDetails,
    };
  }

  TransactionDetails copyWith({
    String? orderId,
    double? amount,
    String? productId,
    List<Map<String, dynamic>>? itemDetails,
  }) {
    return TransactionDetails(
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      productId: productId ?? this.productId,
      itemDetails: itemDetails ?? this.itemDetails,
    );
  }

  @override
  String toString() {
    return 'TransactionDetails(orderId: $orderId, amount: $amount, productId: $productId, itemDetails: $itemDetails)';
  }
}
