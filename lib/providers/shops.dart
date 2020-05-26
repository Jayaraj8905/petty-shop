import 'dart:io';

import 'package:flutter/material.dart';

class Shops with ChangeNotifier {
  List<Shop> _list = [];

  List<Shop> get list {
    return [..._list];
  }

  void addShop(String name, File image) {
    var id = _list.length.toString();
    _list.add(new Shop(id: id, name: name, image: image));
    notifyListeners();
  }

  List<Shop> fetchShops() {
    return this._list;
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