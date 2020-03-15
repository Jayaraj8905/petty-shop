import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/product.dart';
import './../providers/cart.dart';
import './../screens/product_detail_screen.dart';

/**
 * Render the Product Item 
 * Shows the name, price
 * Enable fealibility to add to cart
 */
class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 4, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),       
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName, 
                arguments: product.id
              );
            },
            child: Hero(
                tag: product.id,
                child: FadeInImage(
                  // TODO: REPLACE IT WITH THE FINAL OFFICIAL LOGO OF PETTY SHOP
                  placeholder: AssetImage('assets/images/placeholder.png'), 
                  image: NetworkImage(product.image),
                  fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Theme.of(context).splashColor,
            title: Text(
              product.name
            ),
            trailing: Consumer<Cart>(
              builder: (context, cart, _) {
                return IconButton(
                  icon: Icon(
                    cart.isCartItem(product.id) ? Icons.remove_shopping_cart : Icons.add_shopping_cart
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () => cart.toggleCart(product),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}