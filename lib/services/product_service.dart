// lib/services/product_service.dart
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
        print('DEBUG ProductService: Raw JSON response: ${response.body}'); // <<< GUNAKAN print(), bukan log()
        
        List<Product> products = jsonResponse.map((productJson) {
          try {
            // Panggil Product.fromJson
            Product p = Product.fromJson(productJson);
            print('DEBUG ProductService: Successfully parsed product: ${p.name}');
            return p;
          } catch (e) {
            print('ERROR ProductService: Failed to parse single product: $productJson, Error: $e');
            // Jika parsing satu item gagal, Anda bisa mengembalikan Product default atau membuang error
            return Product(id: 'error', name: 'Error Produk', category: '', price: 0, imagePath: '', stock: 0); 
          }
        }).toList();

        print('DEBUG ProductService: Final list of products (count): ${products.length}');
        return products;
      } else {
        print('ERROR ProductService: Failed to load products - Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR ProductService: Error fetching products: $e');
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
        body: jsonEncode({
          'harga': newPrice,
          'stok': newStock,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('ERROR ProductService: Failed to update product - Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception(
            'Failed to update product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('ERROR ProductService: Error updating product: $e');
      throw Exception('Error updating product: $e');
    }
  }
}