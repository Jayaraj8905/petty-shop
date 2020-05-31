import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shops with ChangeNotifier {
  List<Shop> _list = [];
  final String authToken;
  final String userId;

  Shops(this.authToken, this.userId, this._list);

  List<Shop> get list {
    return [..._list];
  }

  Future<void> addShop(String name, File image) async {
    final timestamp = DateTime.now();
    try {
      final response = await Firestore.instance.collection('shops').add({
        "name": name,
        "image": null,
        "createDate": timestamp.toIso8601String(),
        "userId": userId
      });
      _list.insert(0, new Shop(id: response.documentID, name: name, image: image));
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }

  Future<void> fetchShops() async {
    try {
      final response = await Firestore.instance.collection('shops').where('userId', isEqualTo: userId).getDocuments();
      List<Shop> _fetchedShops = [];
      response.documents.forEach((value) {
        _fetchedShops.add(new Shop(
          id: value.documentID,
          name: value["name"],
          image: value["image"]
        ));
      });
      _list = _fetchedShops.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }
}

class Shop {
  final String id;
  final String name;
  final File image;
  
  Shop({
    @required this.id,
    @required this.name,
    @required this.image
  });
}