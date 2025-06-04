import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductService {
  static String getBaseUrl(BuildContext context) {
    String baseIp;
    if (kIsWeb) {
      baseIp = 'localhost';
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      baseIp = '10.0.2.2';
    } else {
      baseIp = '192.168.1.16';
    }
    return 'http://$baseIp:3000';
  }

  static Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final url = Uri.parse('${getBaseUrl(context)}/api/products');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Product> products = jsonResponse.map((productJson) {
          try {
            return Product.fromJson(productJson);
          } catch (_) {
            return Product(
                id: 'error',
                name: 'Error Produk',
                category: '',
                price: 0,
                imagePath: '',
                stock: 0);
          }
        }).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<bool> updateProduct(
      BuildContext context, String productId, int newPrice, int newStock) async {
    final url = Uri.parse('${getBaseUrl(context)}/api/products/$productId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'harga': newPrice, 'stok': newStock}), // <-- diperbaiki
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
