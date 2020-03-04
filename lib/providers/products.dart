import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
   
  ];

  final String authToken;

  Products(this.authToken, this._items);

  Future<void> fetchProducts() async {
    final url = "https://petty-shop.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      extractedData.forEach((id, value) {
        loadedProducts.add(Product(
          id: id,
          name: value["name"],
          price: value["price"].toDouble(),
          description: value["description"],
          image: value["image"]
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch(e) {
      throw(e);
    }
  }

  List<Product> get items {
    return [..._items];
  }

  void addProduct() {
    // TODO: Add the product here
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((product) {
      return product.id == id;
    });
  }
}