import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/transaction_details.dart';
import '../services/midtrans_service.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  final String? userId;

  const HomeScreen({super.key, this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Product> _productList = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _errorMessage = '';
      _productList = [];
    });
    try {
      final products = await ProductService.fetchAllProducts(context);
      setState(() {
        _productList = products;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat produk: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildProductView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Ikan...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Lele'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Nila'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : _productList.isEmpty
                  ? const Center(child: Text('Tidak ada produk tersedia.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _productList.length,
                      itemBuilder: (context, index) {
                        final product = _productList[index];
                        return ProductCard(
                          product: product,
                          onAddToCart: (selectedProduct) {
                            Provider.of<CartProvider>(context, listen: false).addItem(selectedProduct);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${selectedProduct.name} ditambahkan ke keranjang!')),
                            );
                          },
                          onBuyNow: (selectedProduct) {
                            if (widget.userId == null || widget.userId!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mohon login untuk melanjutkan pembelian.')),
                              );
                              return;
                            }
                            if (selectedProduct.stock <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Maaf, stok produk ini habis.')),
                              );
                              return;
                            }

                            final transactionDetails = TransactionDetails(
                              orderId: 'SINGLE-BUY-${DateTime.now().millisecondsSinceEpoch}',
                              amount: selectedProduct.price.toDouble(),
                              productId: selectedProduct.id,
                              itemDetails: [
                                {
                                  'id': selectedProduct.id,
                                  'name': selectedProduct.name,
                                  'price': selectedProduct.price.toDouble(),
                                  'quantity': 1,
                                }
                              ],
                            );

                            MidtransService.initiateMidtransPayment(
                              userId: widget.userId!,
                              transactionDetails: transactionDetails,
                              context: context,
                            );
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    if (_selectedIndex == 0) {
      currentBody = _buildProductView();
    } else if (_selectedIndex == 1) {
      currentBody = CartScreen(userId: widget.userId);
    } else {
      currentBody = ProfilePage(userId: widget.userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama Pemesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProducts,
          ),
        ],
      ),
      body: currentBody,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount > 0 && _selectedIndex == 0) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${cart.itemCount} Item',
                    style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Bayar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onAddToCart;
  final Function(Product) onBuyNow;

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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imagePath.isNotEmpty)
              Image.network(
                product.imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 100,
                  child: Center(child: Text('Gambar tidak tersedia')),
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
                color: product.stock < 5 && product.stock > 0 ? Colors.orange : (product.stock == 0 ? Colors.red : Colors.green),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Rp ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => onAddToCart(product),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: product.stock > 0 ? () => onBuyNow(product) : null,
                  icon: const Icon(Icons.payment),
                  label: Text(product.stock > 0 ? 'Beli Sekarang' : 'Stok Habis'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: product.stock > 0 ? Colors.deepPurple : Colors.grey,
                    foregroundColor: Colors.white,
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