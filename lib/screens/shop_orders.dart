import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petty_shop/providers/cart.dart';
import 'package:petty_shop/providers/orders.dart';
import 'package:petty_shop/widgets/order_item_widget.dart';

class ShopOrders extends StatelessWidget {
  static const routeName = '/shop-orders';
  const ShopOrders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('orders')
                .where('shopId', isEqualTo: shopId)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final orders = snapshot.data.documents;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, index) {
                  final order = OrderItem(
                      id: orders[index].documentID,
                      price: orders[index]["price"].toDouble(),
                      createDate: DateTime.parse(orders[index]["createDate"]),
                      products: (json.decode(orders[index]["products"])
                              as List<dynamic>)
                          .map((item) {
                        return CartItem(
                            id: item["id"],
                            name: item["name"],
                            price: item["price"].toDouble(),
                            unit_value: item["unit_value"]);
                      }).toList());
                  return OrderItemWidget(order);
                },
              );
            }));
  }
}
