import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './../providers/products.dart';
import './../widgets/products_grid.dart';
import './../widgets/badge.dart';
import './../widgets/app_drawer.dart';
import './cart_screen.dart';

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
                  onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName)
                ),
                value: cart.itemCount.toString(),
              );
            },
          )
          
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchProducts(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else {
            return ProductsGrid();
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}