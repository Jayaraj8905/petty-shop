import 'package:flutter/material.dart';
import './cart.dart';

class OrderItem {
  final int id;
  final int cartId;
  final List<CartItem> products;
  final double price;
  final DateTime createDate;

  OrderItem({
    @required this.id,
    @required this.cartId,
    @required this.products,
    @required this.price,
    @required this.createDate
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  /// Add the order information
  void addOrder(int cartId, List<CartItem> products, double price) {
    _orders.insert(0, 
      OrderItem(
        id: DateTime.now().millisecond,
        cartId: cartId,
        products: products,
        price: price,
        createDate: DateTime.now()
      )
    );
    notifyListeners();
  }
}