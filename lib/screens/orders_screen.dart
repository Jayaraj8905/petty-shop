import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context, listen: false).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: Center(
        child: Text('Orders Screen'),
      ),
    );
  }

}