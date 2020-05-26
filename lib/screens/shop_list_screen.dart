import 'package:flutter/material.dart';
import 'package:petty_shop/screens/product_overview_screen.dart';
import 'package:petty_shop/screens/shop_add_screen.dart';
import 'package:petty_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:petty_shop/providers/shops.dart';

class ShopListScreen extends StatelessWidget {
  static const routeName = '/shops'; 
  @override
  Widget build(BuildContext context) {
    final shopList = Provider.of<Shops>(context, listen: false).fetchShops();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shops'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () => Navigator.of(context).pushNamed(ShopAddScreen.routeName)
          )
        ],
      ),
      body: Consumer<Shops>(
              child: Center(
                child: Text('No shops nearby to you!')
              ),
              builder: (ctx, shops, ch) => shops.list.length == 0 
                ? ch
                : ListView.builder(
                    itemCount: shops.list.length,
                    itemBuilder: (ctx, i) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FileImage(shopList[i].image),
                      ),
                      title: Text(shopList[i].name),
                      trailing: IconButton(
                        icon: Icon(Icons.input), 
                        onPressed: () => {
                          Navigator.of(context).pushNamed(ProductOverviewScreen.routeName)
                        }
                      ),
                    )
                  ),
            ),
      drawer: AppDrawer(),
    );
  }
}