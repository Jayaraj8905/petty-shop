import 'package:flutter/material.dart';
import './screens/product_detail.dart';
import './screens/product_overview.dart';

void main() => runApp(PettyShopApp());

class PettyShopApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petty Shop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrangeAccent,
        fontFamily: 'Lato',
        splashColor: Colors.black87
      ),
      home: ProductOverview(),
      routes: {
        ProductDetail.routeName: (ctx) => ProductDetail()
      },
    );
  }
}
