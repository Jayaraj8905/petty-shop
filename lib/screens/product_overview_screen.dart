import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './../widgets/products_grid.dart';
import './../widgets/badge.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jade Minimart'// TODO: Has to come from the shops list
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, cart, _) {
              return Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => {},
                ),
                value: cart.itemCount.toString(),
              );
            },
          )
          
        ],
      ),
      body: ProductsGrid() 
    );
  }

}