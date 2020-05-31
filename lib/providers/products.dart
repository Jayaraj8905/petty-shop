import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
   
  ];

  final String authToken;

  Products(this.authToken, this._items);

  Future<void> fetchProducts() async {
    try {
      final response = await Firestore.instance.collection('products').getDocuments();
      List<Product> loadedProducts = [];
      response.documents.forEach((product) {
        loadedProducts.add(
          Product(
            id: product.documentID,
            name: product["name"],
            price: product["price"].toDouble(),
            description: product["description"],
            image: product["image"]
          )
        );
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