import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {

  final String id;
  final String productId;
  final String name;
  final double price;
  final int unit_value;

  CartItemWidget(
    this.id,
    this.productId,
    this.name,
    this.price,
    this.unit_value,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(name),
          subtitle: Text('Total: \$${price * unit_value}'),
          trailing: Text('$unit_value x'),
        ),
      ),
    );
  }

}