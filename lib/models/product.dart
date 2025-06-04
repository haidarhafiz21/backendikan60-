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
    return Product(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      price: int.tryParse(json['harga']?.toString() ?? '') ?? 0,
      imagePath: (json['imagePath'] ?? 'https://via.placeholder.com/150').toString(),
      stock: int.tryParse(json['stok']?.toString() ?? '') ?? 0,
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
