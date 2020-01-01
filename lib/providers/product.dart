import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.image
  });
}