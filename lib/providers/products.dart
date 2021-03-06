import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petty_shop/providers/shops.dart';
import './product.dart';
import 'package:path/path.dart' as path;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  Future<void> fetchProducts() async {
    try {
      final documents = await _getProducts();
      List<Product> loadedProducts = [];
      documents.forEach((product) {
        loadedProducts.add(Product(
            id: product.documentID,
            name: product["name"],
            price: product["price"].toDouble(),
            description: product["description"],
            image: product["image"]));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  /// Just query without notifier
  Future<List<Product>> queryProducts({String nameStr}) async {
    try {
      final documents = await _getProducts();
      List<Product> loadedProducts = [];
      documents.forEach((product) {
        if (nameStr != null) {
          // if name str there, filter it based on the contains search
          // TOOD: NEEDS TO MOVE TO DB LAYER. FIREBASE DIDNT HAVE THE FEASIBILITY
          if (!product["name"]
              .toString()
              .toLowerCase()
              .contains(nameStr.toLowerCase())) {
            return;
          }
        }
        loadedProducts.add(Product(
            id: product.documentID,
            name: product["name"],
            price: product["price"].toDouble(),
            description: product["description"],
            image: product["image"]));
      });
      return loadedProducts;
    } catch (e) {
      throw (e);
    }
  }

  List<Product> get items {
    return [..._items];
  }

  /// Add the product to the shop products
  Future<void> addShopProduct(String shopId,
      {String productId,
      String name,
      String description,
      double price,
      File image}) async {
    // TODO: FOLLOW THE TRANSACTION METHODOLOGY
    try {
      // Normalization
      // name = name.toLowerCase();
      // Fetch the shop details from the shop id

      // TODO: Check the user is the shop owner or shop seller

      // check any product already exists with this name
      // TODO: ADD INDEX FOR THE NAME, USERID IN THE PRODUCT
      List<DocumentSnapshot> documents;
      // if product id is there query the product
      if (productId != null) {
        documents = await _getProducts(id: productId);
      } else {
        // else have a check whether the same product exist or not
        documents = await _getProducts(name: name);
      }

      // get or create the productDocRef to store in the shop product
      DocumentReference productDocRef;
      if (documents != null && documents.length > 0) {
        productDocRef = Firestore.instance
            .collection('products')
            .document(documents[0].documentID);
        // override the user provided name by the original product name
        name = documents[0]['name'];
      } else {
        // If the product Id is not there create the product
        productDocRef = await _createProduct(
            name: name,
            description: description,
            price: price,
            image: image,
            userId: this.userId);
      }

      // Check the product is not already there in the shop products
      // if it is not there then create the shop product
      final shopProductDocuments =
          await _getShopProduct(shopId, productDocRef: productDocRef);
      if (shopProductDocuments == null || shopProductDocuments.length == 0) {
        // after the product is added, add the product in the shop_products
        // TODO: INDEX SHOULD BE ADDED FOR (NAME)
        final shopProductDocRef = await _createShopProduct(shopId,
            name: name,
            description: description,
            price: price,
            product: productDocRef,
            image: image,
            userId: this.userId);

        // fetch the added product
        final shopProduct = await shopProductDocRef.get();
        // add the product to the items
        _items.add(Product(
            id: shopProduct.documentID,
            name: shopProduct['name'],
            price: shopProduct['price'].toDouble(),
            description: shopProduct['description'],
            image: shopProduct['image']));
        notifyListeners();
      } else {
        print(":::::Product already exists:::::");
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> fetchByShopProducts(String shopId, {String name}) async {
    try {
      final documents = await _getShopProduct(shopId, name: name);
      List<Product> loadedProducts = [];
      documents.forEach((product) {
        loadedProducts.add(Product(
            id: product.documentID,
            name: product["name"],
            price: product["price"].toDouble(),
            description: product["description"],
            image: product["image"]));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) {
      return product.id == id;
    });
  }

  /// HELPERS WILL BE ADDED BELOW
  /// HELPER FUNCTIONS ARE THE PRIVATE FUNCTION AND IT WILL DO THE INDIVIDUAL OPERATION
  /// THESE FUNCTIONS SHOULD NOT BE USED DIRECTLY BY THE WIDGET OR SCREENS
  /// THEY WILL JUST RETURN THE DOCUMENTREFERENCES FOR CREATION AND SNAPSHOTS FOR THE FETCH
  /// TODO: MOVE TO THE HELPERS FOLDER

  /// Helper to create the product
  Future<DocumentReference> _createProduct(
      {@required String name,
      @required String description,
      @required double price,
      @required File image,
      @required userId}) async {
    final timestamp = DateTime.now();
    final extension = path.extension(image.path);
    final productDocRef = await Firestore.instance.collection('products').add({
      "name": name,
      "description": description,
      "price": price,
      "userId": this.userId
    });

    // Upload the product image
    // create the folder products->{productId}->image_{timestamp in milliseconds}
    final fileuploadRef = FirebaseStorage.instance
        .ref()
        .child('products')
        .child(productDocRef.documentID)
        .child(
            'image_' + timestamp.millisecondsSinceEpoch.toString() + extension);
    await fileuploadRef.putFile(image).onComplete;
    final url = await fileuploadRef.getDownloadURL();

    // update the image url
    await productDocRef.updateData({"image": url});

    return productDocRef;
  }

  /// Helper to get the products
  Future<List<DocumentSnapshot>> _getProducts({String id, String name}) async {
    if (id != null) {
      final document =
          await Firestore.instance.collection('products').document(id).get();
      final list = new List<DocumentSnapshot>();
      list.add(document);
      return list;
    }
    Query collectionReference =
        Firestore.instance.collection('products').reference();
    if (name != null) {
      collectionReference = collectionReference.where('name', isEqualTo: name);
    }
    final response = await collectionReference.getDocuments();
    return response.documents;
  }

  /// Helper to create the shop product
  Future<DocumentReference> _createShopProduct(shopId,
      {@required String name,
      @required String description,
      @required double price,
      @required File image,
      @required DocumentReference product,
      @required userId}) async {
    final timestamp = DateTime.now();
    final extension = path.extension(image.path);
    // NOTE: Added the sub collection name as shop_products instead of products as querying using collectionGroup will search all the documents with the same. So better follow the unique name
    final shopProductDocRef = await Firestore.instance
        .collection('shops')
        .document(shopId)
        .collection('shop_products')
        .add({
      "name": name,
      "description": description,
      "price": price,
      "product": product,
      "userId": userId
    });

    // Upload the product image
    // create the folder shops->{shopId}->shop_products->{shopProductId}->image_{timestamp in milliseconds}
    final fileuploadRef = FirebaseStorage.instance
        .ref()
        .child('shops')
        .child(shopId)
        .child('shop_products')
        .child(shopProductDocRef.documentID)
        .child(
            'image_' + timestamp.millisecondsSinceEpoch.toString() + extension);
    await fileuploadRef.putFile(image).onComplete;
    final url = await fileuploadRef.getDownloadURL();

    // update the image url
    await shopProductDocRef.updateData({"image": url});
    return shopProductDocRef;
  }

  /// Helper to get the products
  Future<List<DocumentSnapshot>> _getShopProduct(String shopId,
      {String name, DocumentReference productDocRef}) async {
    Query collectionReference = Firestore.instance
        .collection('shops')
        .document(shopId)
        .collection('shop_products')
        .reference();
    if (name != null) {
      collectionReference = collectionReference.where('name', isEqualTo: name);
    }
    if (productDocRef != null) {
      collectionReference =
          collectionReference.where('product', isEqualTo: productDocRef);
    }
    final response = await collectionReference.getDocuments();
    return response.documents;
  }
}
