import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/transaction_details.dart';
import '../services/midtrans_service.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'profile_page.dart';
import 'history_screen.dart';

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
  String _selectedCategory = 'Lele';
  String _searchQuery = '';

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

  List<Product> get _filteredProducts {
    if (_searchQuery.isNotEmpty) {
      return _productList
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    } else {
      return _productList
          .where((p) =>
              p.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
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
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'Lele';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedCategory == 'Lele'
                    ? Colors.amber
                    : Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Lele'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'Nila';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedCategory == 'Nila'
                    ? Colors.amber
                    : Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
              : _filteredProducts.isEmpty
                  ? const Center(child: Text('Tidak ada produk tersedia.'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filteredProducts.map((product) {
                          return Container(
                            width: 250,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: ProductCard(
                              product: product,
                              onAddToCart: (selectedProduct) {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addItem(selectedProduct);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${selectedProduct.name} ditambahkan ke keranjang!')),
                                );
                              },
                              onBuyNow: (selectedProduct) {
                                if (widget.userId == null ||
                                    widget.userId!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Mohon login untuk melanjutkan pembelian.')),
                                  );
                                  return;
                                }
                                if (selectedProduct.stock <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Maaf, stok produk ini habis.')),
                                  );
                                  return;
                                }

                                final transactionDetails = TransactionDetails(
                                  orderId:
                                      'SINGLE-BUY-${DateTime.now().millisecondsSinceEpoch}',
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
                            ),
                          );
                        }).toList(),
                      ),
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
    } else if (_selectedIndex == 2) {
      currentBody = HistoryScreen(userId: widget.userId);
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
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histori'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
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
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Bayar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
