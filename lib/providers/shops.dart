import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

class Shops with ChangeNotifier {
  List<Shop> _list = [];
  final String authToken;
  final String userId;

  Shops(this.authToken, this.userId, this._list);

  List<Shop> get list {
    return [..._list];
  }

  Future<void> addShop(String name, File image) async {
    final url = "https://petty-shop.firebaseio.com/shops/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url, 
        body: json.encode({
          "name": name,
          "image": null,
          "createDate": timestamp.toIso8601String(),
        })
      );
      _list.insert(0, new Shop(id: json.decode(response.body)["name"], name: name, image: image));
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }

  Future<void> fetchShops() async {
    final url = "https://petty-shop.firebaseio.com/shops/$userId.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      List<Shop> _fetchedShops = [];
      data.forEach((id, value) {
        print(id);
        _fetchedShops.add(new Shop(
          id: id,
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