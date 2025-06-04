import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final String? userId;

  const HistoryPage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Histori Pembelian',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
