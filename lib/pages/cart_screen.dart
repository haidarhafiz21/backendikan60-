// lib/pages/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../models/transaction_details.dart';
import '../services/midtrans_service.dart';

class CartScreen extends StatelessWidget {
  final String? userId;

  const CartScreen({
    super.key,
    this.userId, 
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column( 
        children: [
          Expanded(
            child: cart.itemCount == 0
                ? const Center(child: Text('Keranjang Anda kosong.'))
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: cartItem.product.imagePath.isNotEmpty
                                ? NetworkImage(cartItem.product.imagePath)
                                : null,
                            child: cartItem.product.imagePath.isEmpty ? const Icon(Icons.image) : null,
                            radius: 25,
                          ),
                          title: Text(cartItem.product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kategori: ${cartItem.product.category}'),
                              Text('Harga Satuan: Rp ${cartItem.product.price.toStringAsFixed(0)}'),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      cart.removeItem(cartItem.product.id);
                                    },
                                  ),
                                  Text('${cartItem.quantity}'),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      if (cartItem.quantity < cartItem.product.stock) {
                                        cart.addItem(cartItem.product);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Stok tidak mencukupi.')),
                                        );
                                      }
                                    },
                                  ),
                                  Text('Total: Rp ${cartItem.totalPrice.toStringAsFixed(0)}'),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cart.deleteItem(cartItem.product.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pesanan:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${cart.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (userId == null || userId!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID pengguna tidak ditemukan. Mohon login ulang.')),
                        );
                        return;
                      }

                      if (cart.itemCount == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Keranjang belanja kosong.')),
                        );
                        return;
                      }

                      final List<Map<String, dynamic>> itemDetailsForMidtrans = cart.items.map((cartItem) => {
                        'id': cartItem.product.id,
                        'name': cartItem.product.name,
                        'price': cartItem.product.price.toDouble(),
                        'quantity': cartItem.quantity,
                      }).toList();

                      final transactionDetails = TransactionDetails(
                        orderId: 'CART-ORDER-${DateTime.now().millisecondsSinceEpoch}',
                        amount: cart.totalAmount,
                        itemDetails: itemDetailsForMidtrans,
                      );

                      MidtransService.initiateMidtransPayment(
                        userId: userId!,
                        transactionDetails: transactionDetails,
                        context: context,
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      'Lanjutkan Pembayaran',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}