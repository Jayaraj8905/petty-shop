import 'package:flutter/material.dart';
import './../models/product.dart';
import './../DATA.dart';

class ProductDetail extends StatelessWidget {

  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments as String;
    final Product product = PRODUCTS.firstWhere((prod) => prod.id == productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 300,
              padding: EdgeInsets.all(10),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Rs.${product.price}',
                ),
                IconButton(
                  icon: Icon(
                    Icons.shopping_basket
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () => {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}