// lib/pages/home_admin_page.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'edit_product_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentIndex = 0; // Untuk bottom navigation

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final products = await ProductService.fetchAllProducts(context);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat produk: $e';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _navigateToEditProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );

    if (result == true) {
      _fetchProducts();
    }
  }

  Widget _buildHomeContent() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
            ? Center(
                child: Text(_errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16)),
              )
            : _products.isEmpty
                ? const Center(child: Text('Tidak ada produk untuk dikelola.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.imagePath.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    product.imagePath,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const SizedBox(
                                      height: 80,
                                      width: 80,
                                      child:
                                          Center(child: Icon(Icons.image, size: 40)),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text('Kategori: ${product.category}',
                                        style: const TextStyle(fontSize: 14)),
                                    Text(
                                        'Harga: Rp ${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 14)),
                                    Text('Stok: ${product.stock}',
                                        style: const TextStyle(fontSize: 14)),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            _navigateToEditProduct(product),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text('Edit',
                                            style: TextStyle(fontSize: 14)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const HistoryPage();
      case 2:
        return const ProfilePage();
      default:
        return const Center(child: Text('Halaman tidak ditemukan'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
