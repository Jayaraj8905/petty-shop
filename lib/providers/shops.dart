import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petty_shop/models/location.dart';

class Shops with ChangeNotifier {
  List<Shop> _list = [];
  final String authToken;
  final String userId;

  Shops(this.authToken, this.userId, this._list);

  List<Shop> get list {
    return [..._list];
  }

  Future<void> addShop(String name, File image, LocationDetails locationDetails) async {
    final timestamp = DateTime.now();
    try {
      final response = await Firestore.instance.collection('shops').add({
        "name": name,
        "createDate": timestamp.toIso8601String(),
        "userId": userId
      });

      // Image upload
      // create the folder shops->{shopid}->{timestamp in milliseconds}
      final fileuploadRef = FirebaseStorage.instance.
                            ref().child('shops').child(response.documentID).child('image_' + timestamp.millisecondsSinceEpoch.toString() + '.jpg');
      await fileuploadRef.putFile(image).onComplete;
      final url = await fileuploadRef.getDownloadURL();

      // update the image url
      await response.updateData({
        "image": url
      });
      await _list.insert(0, new Shop(id: response.documentID, name: name, image: url));
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }

  Future<void> fetchShops() async {
    try {
      // TODO: JUST A HANDLER TO AVOID FETCHING DATA (DUE TO THE PROBLEM IN LOGOUT)
      if (userId == null) {
        throw('Error');
      }
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
  final String image;
  
  Shop({
    @required this.id,
    @required this.name,
    @required this.image
  });
}