import 'package:flutter/material.dart';
import './../providers/products.dart';

/// Individual Cart item

class CartItem {
  final String id;
  final String name;
  final String unit_value;
  final String price; 

  CartItem({
    @required this.id,
    @required this.name,
    @required this.unit_value,
    @required this.price
  });
}

/// Cart
class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final products = Products();

  Map<String, CartItem> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  /// Add or remove from the cart by productId
  void toggleCart(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
    } else {
      final product = products.findById(productId);
      _items.putIfAbsent(product.id, () {
        return CartItem(
          id: new DateTime.now().toString(),
          name: product.name,
          price: product.price,
          unit_value: "1"
        );
      });
    }
    notifyListeners();
  }


}