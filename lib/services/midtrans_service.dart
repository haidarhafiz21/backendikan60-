import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/transaction_details.dart';
import '../pages/payments_page.dart';  // pastikan path ini benar

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

    // Tentukan IP lokal sesuai platform
    String baseIp;
    if (kIsWeb) {
      baseIp = 'localhost';
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      baseIp = '10.0.2.2';  // IP khusus emulator Android
    } else {
      baseIp = '192.168.1.16'; // Ganti dengan IP lokal kamu
    }

    final baseUrl = 'http://$baseIp:3000/api/payment/initiate';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pengguna_id': userId,
          'order_id': transactionDetails.orderId,
          'amount': transactionDetails.amount,
          'item_details': transactionDetails.itemDetails,
        }),
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final transactionToken = responseData['dataPayment']?['token'] ?? responseData['token'];

        if (transactionToken == null || transactionToken.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Token transaksi tidak tersedia.')),
          );
          return;
        }

        // Navigasi ke halaman payment dengan token yang didapat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => PaymentPage(
              midtransToken: transactionToken,
            ),
          ),
        );
      } else {
        final errorMsg = jsonDecode(response.body)['error'] ?? 'Terjadi kesalahan.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal inisialisasi pembayaran: $errorMsg')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan jaringan: $e')),
      );
    }
  }
}
