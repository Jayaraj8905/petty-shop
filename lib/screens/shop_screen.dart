import 'package:flutter/material.dart';
import 'package:petty_shop/providers/shops.dart';
import 'package:petty_shop/screens/product_add_screen.dart';
import 'package:petty_shop/widgets/cart_action.dart';
import 'package:provider/provider.dart';
import './../providers/products.dart';
import './../widgets/products_grid.dart';
import './../widgets/app_drawer.dart';

class ShopScreen extends StatelessWidget {
  static const routeName = '/shop';

  const ShopScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments as String;
    final Shop shop = Provider.of<Shops>(context, listen: false).findById(shopId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          shop.name
        ),
        // TODO: SHOW THIS ONLY FOR THE ADMIN, OWNER OR SELLER OF THE SHOP
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () => Navigator.of(context).pushNamed(ProductAddScreen.routeName, arguments: shop.id)
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => Provider.of<Products>(context, listen: false).fetchByShopProducts(shop.id),
          child: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).fetchByShopProducts(shop.id),
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