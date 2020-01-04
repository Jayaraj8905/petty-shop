import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './../providers/orders.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${order.price}')
                ),
              ),
            ),
            title: Text('Order No: ${order.id}'),
            subtitle: Text(DateFormat('dd MMM yyyy hh:mm').format(order.createDate)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more), onPressed: () {},
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(order.products.length * 20.0 + 10, 100),
            child: ListView(
              children: order.products.map((cartItem) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      cartItem.name
                    ),
                    Text(
                      '\$${cartItem.price} x ${cartItem.unit_value}'
                    )
                  ],
                );
              }).toList()
            ),
          )
        ],
      ),
    );
  }

}