import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> addProduct({String name, String description, double price, File image, String shopId}) async {
    final timestamp = DateTime.now();
    try {
      // Fetch the shop details from the shop id
      
      // Check the user is the shop owner or shop seller

      // If the product Id is not there create the product
      // TODO: ADD THE USERID
      final addProductResponse = await Firestore.instance.collection('products').add({
        "name": name,
        "description": description,
        "price": price
      });

      // Upload the product image
      // create the folder products->{productId}->image_{timestamp in milliseconds}
      final fileuploadRef = FirebaseStorage.instance.
                            ref().child('products').child(addProductResponse.documentID).child('image_' + timestamp.millisecondsSinceEpoch.toString() + '.jpg');
      await fileuploadRef.putFile(image).onComplete;
      final url = await fileuploadRef.getDownloadURL();

      // update the image url
      await addProductResponse.updateData({
        "image": url
      });

      // else If the productId is there, fetch the product
      
      // Check the product is not already there is the shop products 

      // after the product is added, add the product in the shop_products

      // add the product to the items 
      _items.add(
        Product(
          id: addProductResponse.documentID,
          name: name,
          price: price.toDouble(),
          description: description,
          image: url
        )
      );
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }

  Future<void> fetchByShopProducts() async {
    try {
      final response = await Firestore.instance.collection('shop_products').reference().where('field', isEqualTo: 'test').getDocuments();
      List<Product> loadedProducts = [];
      response.documents.forEach((product) {
        print(product);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch(e) {
      throw(e);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) {
      return product.id == id;
    });
  }
}