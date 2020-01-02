import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './../providers/products.dart';
import './../screens/cart_screen.dart';
import './../widgets/badge.dart';
import './../widgets/counter.dart';

class ProductDetailScreen extends StatelessWidget {

  List<Widget> cartWidgets(CartItem cartItem, String productId, BuildContext context) {
    List<Widget> list = [];
    if (cartItem != null) {
      list.add(Chip(
        label: Text(
          '\$${cartItem.price * cartItem.unit_value}',
          style: TextStyle(
            color: Theme.of(context).primaryTextTheme.title.color
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      list.add(Counter(
        defaultVal: cartItem.unit_value,
        onCounter: (val) {
          Provider.of<Cart>(context, listen: false).updateUnitValue(
            productId,
            val  
          );
        },
      ));
    }
    return list;
  }

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
          product.name
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, cart, _) {
              return Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => {
                    Navigator.of(context).pushNamed(CartScreen.routeName)
                  },
                ),
                value: cart.itemCount.toString(),
              );
            },
          )
          
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${product.description}',
                style: Theme.of(context).textTheme.body1,
              ),
            ),
          ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Consumer<Cart>(
              builder: (context, cart, _) {
                final cartItem = Provider.of<Cart>(
                  context,
                  listen: false,
                ).findByProductId(productId);
                return Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            cartItem != null ? Icons.remove_shopping_cart : Icons.add_shopping_cart
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () => cart.toggleCart(product.id),
                        ),
                        Spacer(),
                        ...cartWidgets(cartItem, productId, context).toList()         
                      ],
                    ),
                    
                  ),
                ); 
              }, 
            ),
          )
        ]),
    );
  }

}