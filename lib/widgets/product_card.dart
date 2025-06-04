import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final void Function(Product) onAddToCart;
  final void Function(Product) onBuyNow;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      height: 100,
                      child: Center(child: Text('Gambar tidak tersedia')),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Kategori: ${product.category}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 5),
            Text(
              'Stok: ${product.stock}',
              style: TextStyle(
                fontSize: 14,
                color: product.stock < 5 && product.stock > 0
                    ? Colors.orange
                    : (product.stock == 0 ? Colors.red : Colors.green),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Rp ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onAddToCart(product),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Tambah'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: product.stock > 0 ? () => onBuyNow(product) : null,
                    icon: const Icon(Icons.payment, size: 18),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        product.stock > 0 ? 'Beli Sekarang' : 'Stok Habis',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: product.stock > 0 ? Colors.deepPurple : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
