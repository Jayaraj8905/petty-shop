import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../widgets/product_item.dart';
import './../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
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
    );
  }

}