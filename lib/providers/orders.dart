import 'package:flutter/material.dart';
import 'dart:convert';
import './cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String id;
  final String shopId;
  final List<CartItem> products;
  final double price;
  final DateTime createDate;

  OrderItem(
      {@required this.id,
      @required this.shopId,
      @required this.products,
      @required this.price,
      @required this.createDate});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchMyOrders() async {
    try {
      // TODO: JUST A HANDLER TO AVOID FETCHING DATA (DUE TO THE PROBLEM IN LOGOUT)
      if (userId == null) {
        throw ('Error');
      }

      final documents = await _getOrders(userId: userId);
      final loadedOrders = convertDocSnapShotToOrderItemList(documents);
      notifyListeners();
      _orders = loadedOrders.reversed.toList();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> fetchShopOrders(String shopId) async {
    try {
      // TODO: JUST A HANDLER TO AVOID FETCHING DATA (DUE TO THE PROBLEM IN LOGOUT)
      if (userId == null) {
        throw ('Error');
      }

      // TODO: CHECK THE USER ID IS THE OWNER OF THE SHOP

      final documents = await _getOrders(shopId: shopId);
      final loadedOrders = convertDocSnapShotToOrderItemList(documents);
      notifyListeners();
      _orders = loadedOrders.reversed.toList();
    } catch (e) {
      throw (e);
    }
  }

  /// Add the order information
  Future<void> addOrder(
      String shopId, List<CartItem> products, double price) async {
    if (shopId == null) {
      throw ('Shop Id is required');
    }
    final timestamp = DateTime.now();
    try {
      await Firestore.instance.collection('orders').add({
        "shopId": shopId,
        "price": price,
        "createDate": timestamp.toIso8601String(),
        'userId': userId,
        "products": json.encode(products
            .map((cp) => {
                  "id": cp.id,
                  "name": cp.name,
                  "price": cp.price,
                  "unit_value": cp.unit_value
                })
            .toList())
      });
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  /// Cast document to orderItems
  List<OrderItem> convertDocSnapShotToOrderItemList(
      List<DocumentSnapshot> documents) {
    List<OrderItem> orders = [];
    documents.forEach((orderData) {
      orders.add(OrderItem(
          id: orderData.documentID,
          shopId: orderData["shopId"],
          price: orderData["price"].toDouble(),
          createDate: DateTime.parse(orderData["createDate"]),
          products:
              (json.decode(orderData["products"]) as List<dynamic>).map((item) {
            return CartItem(
                id: item["id"],
                name: item["name"],
                price: item["price"].toDouble(),
                unit_value: item["unit_value"]);
          }).toList()));
    });
    return orders;
  }

  /// Helper to get the orders
  Future<List<DocumentSnapshot>> _getOrders(
      {String shopId, String userId}) async {
    Query collectionReference =
        Firestore.instance.collection('orders').reference();
    if (shopId != null) {
      collectionReference =
          collectionReference.where('shopId', isEqualTo: shopId);
    }
    if (userId != null) {
      collectionReference =
          collectionReference.where('userId', isEqualTo: userId);
    }
    final response = await collectionReference.getDocuments();
    return response.documents;
  }
}
