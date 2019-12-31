import 'package:flutter/material.dart';
import 'package:petty_shop/widgets/product_item.dart';
import './../models/product.dart';
import './../DATA.dart';

class ProductOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final List<Product>products = PRODUCTS;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jade Minimart'// TODO: Has to come from the shops list
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (ctx, index) {
          return ProductItem(
            id: products[index].id,
            title: products[index].title,
            image: products[index].image,
            price: products[index].price,
          );
        },
        itemCount: products.length, 
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
      )
    );
  }

}