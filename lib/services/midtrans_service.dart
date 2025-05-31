// lib/services/midtrans_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/transaction_details.dart';
import '../pages/payments_page.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

class MidtransService {
  static Future<void> initiateMidtransPayment({
    required String userId,
    required TransactionDetails transactionDetails,
    required BuildContext context,
  }) async {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID pengguna tidak ditemukan. Mohon login ulang.')),
      );
      return;
    }

    if (transactionDetails.amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah pembayaran tidak valid.')),
      );
      return;
    }

    print('Memulai inisialisasi pembayaran Midtrans:');
    print('User ID: $userId');
    print('Order ID: ${transactionDetails.orderId}');
    print('Jumlah: ${transactionDetails.amount}');
    print('Produk ID: ${transactionDetails.productId ?? 'N/A'}');
    print('Detail Item: ${transactionDetails.itemDetails ?? 'N/A'}');

    String baseIp;
    if (kIsWeb) {
      baseIp = 'localhost';
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      baseIp = 'localhost';
    } else {
      baseIp = '192.168.1.16';
    }
    final String baseUrl = 'http://$baseIp:3000';

    // Untuk produksi, ganti ini dengan panggilan API backend Anda.
    /*
    final url = Uri.parse('$baseUrl/api/payment/initiate');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'order_id': transactionDetails.orderId,
          'amount': transactionDetails.amount,
          'item_details': transactionDetails.itemDetails,
        }),
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String transactionToken = responseData['transaction_token'];
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => PaymentsPage(
              userId: userId,
              transactionDetails: transactionDetails,
              midtransToken: transactionToken,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal inisialisasi pembayaran: ${response.body}')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan jaringan: $e. Pastikan backend berjalan dan URL benar.')),
      );
    }
    */

    await Future.delayed(const Duration(seconds: 1));
    const String simulatedMidtransToken = 'SIMULATED_TOKEN_FOR_DEMO_ABC123';

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PaymentsPage(
          userId: userId,
          transactionDetails: transactionDetails,
          midtransToken: simulatedMidtransToken,
        ),
      ),
    );
  }
}