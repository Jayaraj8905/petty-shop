import 'package:flutter/material.dart';
import 'package:petty_shop/screens/product_add_screen.dart';
import 'package:petty_shop/widgets/cart_action.dart';
import 'package:provider/provider.dart';
import './../providers/products.dart';
import './../widgets/products_grid.dart';
import './../widgets/app_drawer.dart';

class ProductOverviewScreen extends StatelessWidget {
  
  static const routeName = '/products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jade Minimart'// TODO: Has to come from the shops list
        ),
        // TODO: SHOW THIS ONLY FOR THE ADMIN, OWNER OR SELLER OF THE SHOP
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () => Navigator.of(context).pushNamed(ProductAddScreen.routeName)
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => Provider.of<Products>(context, listen: false).fetchProducts(),
          child: FutureBuilder(
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
      ),
      drawer: AppDrawer(),
      floatingActionButton: CartAction(),
    );
  }
}