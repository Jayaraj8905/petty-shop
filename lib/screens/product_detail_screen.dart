import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false
    ).findById(productId);
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