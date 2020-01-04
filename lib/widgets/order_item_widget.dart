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
      child: ListTile(
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
    );
  }

}