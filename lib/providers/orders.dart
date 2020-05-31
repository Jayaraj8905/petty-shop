import 'package:flutter/material.dart';
import 'dart:convert';
import './cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      final response = await Firestore.instance.collection('orders').where('userId', isEqualTo: userId).getDocuments();
      List<OrderItem> loadedOrders = [];
      response.documents.forEach((orderData) {
        loadedOrders.add(OrderItem(
          id: orderData.documentID,
          price: orderData["price"].toDouble(),
          createDate: DateTime.parse(orderData["createDate"]),
          products: (json.decode(orderData["products"]) as List<dynamic>).map((item) {
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
    final timestamp = DateTime.now();
    try {
      await Firestore.instance.collection('orders').add({
        "price": price,
        "createDate": timestamp.toIso8601String(),
        'userId': userId,
        "products": json.encode(products.map((cp) => {
          "id": cp.id,
          "name": cp.name,
          "price": cp.price,
          "unit_value": cp.unit_value
        }).toList())
      });
      notifyListeners();
    } catch(e) {
      throw(e);
    }
  }
}