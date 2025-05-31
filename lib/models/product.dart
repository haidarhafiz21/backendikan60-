// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final String imagePath;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Tambahkan log untuk melihat data JSON per item
    print('DEBUG Product.fromJson raw json: $json'); 
    return Product(
      // Pastikan konversi tipe data eksplisit dan aman
      id: json['id']?.toString() ?? '', // Pastikan id selalu String
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: int.tryParse(json['harga']?.toString() ?? '0') ?? 0, // Pastikan harga selalu int
      imagePath: json['imagePath']?.toString() ?? '', // Pastikan imagePath selalu String
      stock: int.tryParse(json['stok']?.toString() ?? '0') ?? 0, // Pastikan stok selalu int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'harga': price,
      'imagePath': imagePath,
      'stok': stock,
    };
  }
}