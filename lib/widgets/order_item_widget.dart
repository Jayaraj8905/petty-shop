import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './../providers/orders.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _isExpanded = false;
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
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;  
              });
            },
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${widget.order.price}')
                ),
              ),
            ),
            title: Text('Order No: ${widget.order.id}'),
            subtitle: Text(DateFormat('dd MMM yyyy hh:mm').format(widget.order.createDate)),
            trailing: _isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more)
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products.map((cartItem) {
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