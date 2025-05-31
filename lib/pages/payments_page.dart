// lib/pages/payments_page.dart
import 'package:flutter/material.dart';
import '../models/transaction_details.dart';
// import 'package:webview_flutter/webview_flutter.dart'; // Uncomment jika menggunakan webview_flutter
// import 'package:url_launcher/url_launcher.dart'; // Uncomment jika menggunakan url_launcher

class PaymentsPage extends StatelessWidget {
  final String userId;
  final TransactionDetails transactionDetails;
  final String midtransToken;

  const PaymentsPage({
    super.key, // Perbaikan: Gunakan super.key bukan Key? key
    required this.userId,
    required this.transactionDetails,
    required this.midtransToken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.receipt_long, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                'Detail Transaksi Anda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildDetailRow('User ID:', userId),
              _buildDetailRow('Order ID:', transactionDetails.orderId),
              _buildDetailRow('Total Bayar:', 'Rp ${transactionDetails.amount.toStringAsFixed(0)}'),
              if (transactionDetails.productId != null)
                _buildDetailRow('Produk ID:', transactionDetails.productId!),
              const SizedBox(height: 30),
              Text(
                'Token Pembayaran (Snap): $midtransToken',
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final String midtransPaymentUrl = 'https://app.midtrans.com/snap/v2/vtweb/$midtransToken';

                    // Contoh 1: Menggunakan webview_flutter (Uncomment jika ingin pakai)
                    /*
                    // Pastikan Anda sudah menambahkan webview_flutter di pubspec.yaml
                    // Anda mungkin perlu membuat WebViewScreen terpisah seperti ini:
                    // class WebViewScreen extends StatefulWidget {
                    //   final String url;
                    //   const WebViewScreen({Key? key, required this.url}) : super(key: key);
                    //   @override
                    //   State<WebViewScreen> createState() => _WebViewScreenState();
                    // }
                    // class _WebViewScreenState extends State<WebViewScreen> {
                    //   late final WebViewController controller;
                    //   @override
                    //   void initState() {
                    //     super.initState();
                    //     controller = WebViewController()
                    //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    //       ..loadRequest(Uri.parse(widget.url));
                    //   }
                    //   @override
                    //   Widget build(BuildContext context) {
                    //     return Scaffold(
                    //       appBar: AppBar(title: const Text('Pembayaran')),
                    //       body: WebViewWidget(controller: controller),
                    //     );
                    //   }
                    // }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => WebViewScreen(url: midtransPaymentUrl),
                    //   ),
                    // );
                    */

                    // Contoh 2: Menggunakan url_launcher (Uncomment jika ingin pakai)
                    /*
                    // import 'package:url_launcher/url_launcher.dart';
                    // if (await canLaunchUrl(Uri.parse(midtransPaymentUrl))) {
                    //   await launchUrl(Uri.parse(midtransPaymentUrl));
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Tidak dapat membuka halaman pembayaran.')),
                    //   );
                    // }
                    */

                    print('Mengarahkan ke halaman pembayaran Midtrans dengan URL: $midtransPaymentUrl');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mengarahkan ke halaman pembayaran Midtrans...')),
                    );
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text(
                    'Buka Halaman Pembayaran Midtrans',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}