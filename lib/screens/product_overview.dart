import 'package:flutter/material.dart';

class ProductOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jade Minimart'// TODO: Has to come from the shops list
        ),
      ),
      body: Center(
        child: Text('Product Oveview Screen Skeleton'),
      ),
    );
  }

}