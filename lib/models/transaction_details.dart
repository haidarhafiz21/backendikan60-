// lib/models/transaction_details.dart
class TransactionDetails {
  final String orderId;
  final double amount;
  final String? productId;
  final List<Map<String, dynamic>>? itemDetails;

  TransactionDetails({
    required this.orderId,
    required this.amount,
    this.productId,
    this.itemDetails,
  });
}