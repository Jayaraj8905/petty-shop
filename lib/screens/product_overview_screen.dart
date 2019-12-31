import 'package:flutter/material.dart';
import './../widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jade Minimart'// TODO: Has to come from the shops list
        ),
      ),
      body: ProductsGrid() 
    );
  }

}