import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petty_shop/providers/cart.dart';
import 'package:petty_shop/providers/orders.dart';
import 'package:petty_shop/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

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
              final orders = Provider.of<Orders>(context, listen: false)
                  .convertDocSnapShotToOrderItemList(snapshot.data.documents);
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, index) {
                  return OrderItemWidget(orders[index]);
                },
              );
            }));
  }
}
