import 'package:flutter/material.dart';
import './../providers/products.dart';

/// Individual Cart item

class CartItem {
  final String id;
  final String name;
  final int unit_value;
  final double price; 

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

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.unit_value;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  bool isCartItem(productId) {
    return _items.containsKey(productId);
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
          unit_value: 1
        );
      });
    }
    notifyListeners();
  }

  /// Update the unitValue (quantity)
  void updateUnitValue(String productId, int unitValue) {
    _items.update(productId, (cart) {
      return CartItem(
        id: cart.id,
        name: cart.name,
        price: cart.price,
        unit_value: unitValue
      );
    });
    notifyListeners();
  }
}