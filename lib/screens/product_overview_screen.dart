import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './../providers/products.dart';
import './../widgets/products_grid.dart';
import './../widgets/badge.dart';
import './../widgets/app_drawer.dart';
import './cart_screen.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration.zero).then((_) => 
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An Error occurred!"),
            content: Text("Something went wrong"),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        );
      })
    );
    super.initState();
  }

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
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ProductsGrid(),
      drawer: AppDrawer(),
    );
  }
}