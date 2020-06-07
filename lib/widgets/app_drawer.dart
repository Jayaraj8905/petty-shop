import 'package:flutter/material.dart';
import 'package:petty_shop/screens/product_overview_screen.dart';
import 'package:petty_shop/screens/shop_list_screen.dart';
import 'package:provider/provider.dart';
import './../screens/orders_screen.dart';
import './../providers/auth.dart';

class AppDrawer extends StatelessWidget {

  leaveShop(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Implementation in Progress'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are about to leave the shop.'),
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  logout(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to Logout?')
              ],
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context).logout();
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Raj!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shops'),
            onTap: () => Navigator.of(context).pushReplacementNamed(ShopListScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Products'),
            onTap: () => Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.arrow_left),
            title: Text('Bye bye!!'),
            onTap: () {
              Navigator.of(context).pop();
              leaveShop(context);
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.arrow_left),
            title: Text('Logout!!'),
            onTap: () {
              Navigator.of(context).pop();
              logout(context);
            }
          ),
        ],
      ),
    );
  }

}