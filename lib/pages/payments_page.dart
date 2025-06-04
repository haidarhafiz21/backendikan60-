import 'dart:io'; // untuk cek platform
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  final String midtransToken;

  const PaymentPage({Key? key, required this.midtransToken}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // Initialize controller only for mobile platforms
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (_) {
              setState(() {
                isLoading = false;
              });
            },
          ),
        )
        ..loadRequest(
          Uri.parse('https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.midtransToken}'),
        );
    }
  }

  Future<void> _launchInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa membuka URL di browser')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentUrl = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.midtransToken}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: kIsWeb
          ? Center(
              child: ElevatedButton(
                onPressed: () => _launchInBrowser(paymentUrl),
                child: Text('Buka Pembayaran di Browser'),
              ),
            )
          : (Platform.isAndroid || Platform.isIOS)
              ? Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                )
              : Center(
                  child: Text('Platform ini tidak didukung WebView'),
                ),
    );
  }
}
