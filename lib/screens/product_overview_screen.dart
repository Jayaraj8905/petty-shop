import 'package:flutter/material.dart';
import 'package:petty_shop/providers/shops.dart';
import 'package:petty_shop/screens/product_add_screen.dart';
import 'package:petty_shop/widgets/cart_action.dart';
import 'package:provider/provider.dart';
import './../providers/products.dart';
import './../widgets/products_grid.dart';
import './../widgets/app_drawer.dart';

class ProductOverviewScreen extends StatelessWidget {
  static const routeName = '/products';

  // TODO: CLEAR THE PRODUCTS OF THE OTHER SHOPS IF ANY

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Products>(context, listen: false).fetchProducts(),
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
