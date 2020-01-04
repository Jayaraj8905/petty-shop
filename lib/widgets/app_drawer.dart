import 'package:flutter/material.dart';
import './../screens/orders_screen.dart';

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
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
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
        ],
      ),
    );
  }

}