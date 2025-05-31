// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items]; 

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity); 

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product) {
    final existingItemIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].incrementQuantity();
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners(); 
  }

  void removeItem(String productId) {
    final existingItemIndex = _items.indexWhere((item) => item.product.id == productId);

    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].decrementQuantity();
      } else {
        _items.removeAt(existingItemIndex);
      }
      notifyListeners();
    }
  }

  void deleteItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}