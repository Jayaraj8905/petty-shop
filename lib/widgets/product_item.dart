import 'package:flutter/material.dart';
import './../screens/product_detail_screen.dart';

/**
 * Render the Product Item 
 * Shows the name, price
 * Enable fealibility to add to cart
 */
class ProductItem extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String image;

  ProductItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.image
  });

  @override
  Widget build(BuildContext context) {
    
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
                arguments: this.id
              );
            },
            child: Center(
              child: Image.network(
                image,
                fit: BoxFit.fill,
              )
            )
          ),
          footer: GridTileBar(
            backgroundColor: Theme.of(context).splashColor,
            title: Text(
              this.name
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_basket
              ),
              color: Theme.of(context).accentColor,
              onPressed: () => {},
            ),
          ),
        ),
      ),
    );
  }

}