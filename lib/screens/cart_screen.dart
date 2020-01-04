import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './../providers/orders.dart';
import './../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      key: _scaffoldKey, // TODO: Temporary solution to show the snack bar, until the review order implemntation
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color
                      ),
                      
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('Order now'),
                    onPressed: () {
                      if (cart.itemCount == 0) {
                        final snackBar = SnackBar(
                          content: Text('No Items in the cart!!!'),
                          duration: Duration(seconds: 1),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      Provider.of<Orders>(context, listen: false)
                      .addOrder(cart.items.values.toList(), cart.totalAmount);
                        final snackBar = SnackBar(
                          content: Text('Ordered!!!'),
                          duration: Duration(seconds: 1),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return CartItemWidget(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].name,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].unit_value,
                );
              },
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}