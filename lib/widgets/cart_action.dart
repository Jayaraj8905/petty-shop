import 'package:flutter/material.dart';
import 'package:petty_shop/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:petty_shop/providers/cart.dart';
import 'package:petty_shop/widgets/badge.dart';

class CartAction extends StatelessWidget {
  final String shopId;
  const CartAction({
    Key key,
    @required this.shopId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Consumer<Cart>(
          builder: (context, cart, _) {
            return Badge(
              child: Icon(Icons.shopping_cart),
              value: cart.itemCount.toString(),
              // color: Theme.of(context).primaryColor,
            );
          },
        ),
        onPressed: () => Navigator.of(context)
            .pushNamed(CartScreen.routeName, arguments: shopId));
  }
}
