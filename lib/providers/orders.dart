import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double price;
  final DateTime createDate;

  OrderItem({
    @required this.id,
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

  Future<void> fetchOrders() async {
    final url = "https://petty-shop.firebaseio.com/orders.json";
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      List<OrderItem> loadedOrders = [];
      data.forEach((id, orderData) {
        loadedOrders.add(OrderItem(
          id: id,
          price: orderData["price"].toDouble(),
          createDate: DateTime.parse(orderData["createDate"]),
          products: (orderData["products"] as List<dynamic>).map((item) {
            return CartItem(
              id: item["id"],
              name: item["name"],
              price: item["price"].toDouble(),
              unit_value: item["unit_value"]
            );
          }).toList()
        ));
      });
      notifyListeners();
      _orders = loadedOrders.reversed.toList();
    } catch(e) {
      throw(e);
    }
    
  }

  /// Add the order information
  Future<void> addOrder(List<CartItem> products, double price) async {
    final url = "https://petty-shop.firebaseio.com/orders.json";
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url, 
        body: json.encode({
          "price": price,
          "createDate": timestamp.toIso8601String(),
          "products": products.map((cp) => {
            "id": cp.id,
            "name": cp.name,
            "price": cp.price,
            "unit_value": cp.unit_value
          }).toList()
        })
      );
      _orders.insert(0, 
        OrderItem(
          id: json.decode(response.body)["name"],
          products: products,
          price: price,
          createDate: timestamp
        )
      );
      notifyListeners();
    } catch(e) {
      throw(e);
    }
  }
}