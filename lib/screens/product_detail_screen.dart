import 'package:flutter/material.dart';
import 'package:petty_shop/providers/cart.dart';
import 'package:petty_shop/widgets/counter.dart';
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
          product.name
        ),
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
                return Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            cart.isCartItem(product.id) ? Icons.remove_shopping_cart : Icons.add_shopping_cart
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () => cart.toggleCart(product.id),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            '\$${cart.totalAmount}',
                            style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color
                            ),
                            
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        Counter(
                          defaultVal: 1,
                          onCounter: (val) {
                            print(val);
                            // Provider.of<Cart>(context, listen: false).updateUnitValue(
                            //   productId,
                            //   val  
                            // );
                          },
                        )
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