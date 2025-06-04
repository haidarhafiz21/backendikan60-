import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final String? userId;

  const HistoryScreen({super.key, this.userId});

  // Contoh data dummy pesanan (nanti bisa diganti dari API/Database)
  List<Map<String, dynamic>> getOrders() {
    return [
      {
        'product': 'Lele Bersih',
        'quantity': 2,
        'price': 50000,
        'status': 'Selesai',
        'date': '2025-06-01',
      },
      {
        'product': 'Nila Bumbu',
        'quantity': 1,
        'price': 40000,
        'status': 'Menunggu Pembayaran',
        'date': '2025-05-31',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final orders = getOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('Belum ada riwayat pembelian.'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(order['product']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jumlah: ${order['quantity']}'),
                        Text('Tanggal: ${order['date']}'),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Rp ${order['price']}'),
                        Text(
                          order['status'],
                          style: TextStyle(
                            color: order['status'] == 'Selesai' ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
