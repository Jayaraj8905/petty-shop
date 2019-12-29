import 'package:flutter/material.dart';

/**
 * Render the Product Item 
 * Shows the title, price
 * Enable fealibility to add to cart
 */
class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final String image;

  ProductItem({
    @required this.id,
    @required this.title,
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
              this.title
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