import 'package:flutter/material.dart';

class ShopAddScreen extends StatefulWidget {
  static const routeName ='/auth';
  ShopAddScreen({Key key}) : super(key: key);

  @override
  _ShopAddScreenState createState() => _ShopAddScreenState();
}

class _ShopAddScreenState extends State<ShopAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your shop'),
      ),
      body: Column(
        children: <Widget>[
          Text('Add shop form')
        ],
      ),
    );
  }
}