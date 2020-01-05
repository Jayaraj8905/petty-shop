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
                  OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Order now'),
      // child: Text('Order now'),
      onPressed: widget.cart.totalAmount <= 0 || _isLoading
        ? null
        : () async {
            setState(() {
              _isLoading = true;
            });
            try {
              await Provider.of<Orders>(context, listen: false)
              .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              final snackBar = SnackBar(
                content: Text('Order Placed!!!'),
                duration: Duration(seconds: 1),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              widget.cart.clear();
            } catch(e) {
              setState(() {
                _isLoading = false;
              });
              final snackBar = SnackBar(
                content: Text('Order not Placed. Something went wrong!'),
                duration: Duration(seconds: 1),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            }
            
          },
      textColor: Theme.of(context).primaryColor,
    );
  }
}