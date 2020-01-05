import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './../providers/products.dart';
import './counter.dart';

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
    final product = Provider.of<Products>(context, listen: false).findById(productId);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).primaryIconTheme.color,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).toggleCart(
          product
        );
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
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
          trailing: Counter(
            defaultVal: unit_value,
            onCounter: (val) {
              Provider.of<Cart>(context, listen: false).updateUnitValue(
                productId,
                val  
              );
            },
          )
        ),
      ),
    );
    
  }

}