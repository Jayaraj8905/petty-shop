import 'package:flutter/material.dart';
import 'package:petty_shop/screens/product_overview_screen.dart';
import 'package:petty_shop/screens/shop_add_screen.dart';
import 'package:petty_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:petty_shop/providers/shops.dart';

class ShopListScreen extends StatelessWidget {
  static const routeName = '/shops'; 
  double radius = 5;
  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Shops>(context, listen: false).fetchShops(radius: this.radius),
        child: FutureBuilder(
          future: Provider.of<Shops>(context, listen: false).fetchShops(radius: this.radius),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            } else {
              return Consumer<Shops>(
                child: Center(
                  child: Text('No shops nearby to you!')
                ),
                builder: (ctx, shops, ch) => shops.list.length == 0 
                  ? ch
                  : ListView.builder(
                  itemCount: shops.list.length,
                  itemBuilder: (ctx, i) => ListTile(
                    leading: shops.list[i].image == null
                      ? CircleAvatar(
                        child: Text(
                          shops.list[i].name[0].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ) 
                      : CircleAvatar(
                          backgroundImage: NetworkImage(shops.list[i].image),
                      ),
                    title: Text(shops.list[i].name),
                    trailing: IconButton(
                      icon: Icon(Icons.input), 
                      onPressed: () => {
                        Navigator.of(context).pushNamed(ProductOverviewScreen.routeName)
                      }
                    ),
                  )
                ),
              );
            }
          }
        )
      ),
      
      drawer: AppDrawer(),
    );
  }
}