import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:petty_shop/models/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Shops with ChangeNotifier {
  List<Shop> _list = [];
  final String authToken;
  final String userId;
  Geoflutterfire geoFire = Geoflutterfire();

  Shops(this.authToken, this.userId, this._list);

  List<Shop> get list {
    return [..._list];
  }

  Future<void> addShop(String name, File image, LocationDetails locationDetails) async {
    final GeoFirePoint geoFirePoint = geoFire.point(latitude: locationDetails.latitude, longitude: locationDetails.longitude);
    try {
      // Add the shop using helper
      final shopDocRef = await _createShop(name: name, userId: userId, image: image, geoFirePoint: geoFirePoint);

      // fetch the added product
      final shop = await shopDocRef.get();

      _list.insert(0, new Shop(id: shop.documentID, name: shop['name'], image: shop['image'], locationDetails: locationDetails));
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }

  Future<void> fetchShops({double radius, LocationDetails locationDetails}) async {
    try {
      // TODO: JUST A HANDLER TO AVOID FETCHING DATA (DUE TO THE PROBLEM IN LOGOUT)
      if (userId == null) {
        throw('Error');
      }

      List<DocumentSnapshot> documents = await _getShops(radius: radius, locationDetails: locationDetails);
      
      List<Shop> _fetchedShops = [];
      documents.forEach((value) {
        final GeoPoint geoPoint = value["point"]["geopoint"];
        _fetchedShops.add(new Shop(
          id: value.documentID,
          name: value["name"],
          image: value["image"],
          locationDetails: new LocationDetails(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        ));
      });
      _list = _fetchedShops.toList();
      notifyListeners();
    } catch (e) {
      throw(e);
    }
  }

  Shop findById(String id) {
    return _list.firstWhere((shop) {
      return shop.id == id;
    });
  }

  /// HELPERS WILL BE ADDED BELOW
  /// HELPER FUNCTIONS ARE THE PRIVATE FUNCTION AND IT WILL DO THE INDIVIDUAL OPERATION
  /// THESE FUNCTIONS SHOULD NOT BE USED DIRECTLY BY THE WIDGET OR SCREENS
  /// THEY WILL JUST RETURN THE DOCUMENTREFERENCES FOR CREATION AND SNAPSHOTS FOR THE FETCH
  /// TODO: MOVE TO THE HELPERS FOLDER
  
  /// Helper to create the product
  Future<DocumentReference> _createShop({@required String name, @required String userId, @required File image, 
                                              @required GeoFirePoint geoFirePoint}) async {
    final timestamp = DateTime.now();                                            
    final shopDocRef = await Firestore.instance.collection('shops').add({
      "name": name,
      "createdDate": timestamp.toIso8601String(),
      "userId": userId,
      "point": geoFirePoint.data,
      "modifiedDate": timestamp.toIso8601String()
    });

    // Image upload
    // create the folder shops->{shopid}->image_{timestamp in milliseconds}
    final fileuploadRef = FirebaseStorage.instance.
                          ref().child('shops').child(shopDocRef.documentID).child('image_' + timestamp.millisecondsSinceEpoch.toString() + '.jpg');
    await fileuploadRef.putFile(image).onComplete;
    final url = await fileuploadRef.getDownloadURL();

    // update the image url
    await shopDocRef.updateData({
      "image": url
    });

    return shopDocRef;
  }

  /// Helper to get the products
  Future<List<DocumentSnapshot>> _getProduct({String id, String name}) async {
    Query collectionReference = Firestore.instance.collection('products').reference();
    if (name != null) {
      collectionReference = collectionReference.where('name', isEqualTo: name);
    }
    final response = await collectionReference.getDocuments();
    return response.documents;
  }

  /// TODO: APPLY THE LIMIT  
  /// Helper to get the products
  Future<List<DocumentSnapshot>> _getShops({String id, String name, double radius, LocationDetails locationDetails, String userId}) async {
    List<DocumentSnapshot> documents;
    // if id is there just fetch and return
    // No need to go through the further checks
    if (id != null) {
      final document = await Firestore.instance.collection('shops').document(id).get();
      final list = new List();
      list.add(document);
      return list;
    }
    // else go through through the further query construction
    Query collectionReference = Firestore.instance.collection('shops').reference();
    // if id is there just return it
    
    if (userId != null) {
      collectionReference = collectionReference.where('userId', isEqualTo: userId);
    }
    
    // if radius is there construct the center point based on the locationDetails and query using geofire.. This one should be happen at the last of all the where conditions
    if (radius != null) {
      // check whether the location details is available
      // if not available get the curren location
      if (locationDetails == null) {
        // get the current user location
        final locationData = await Location().getLocation();
        locationDetails = LocationDetails(latitude: locationData.latitude, longitude: locationData.longitude);
      }

      GeoFirePoint center = geoFire.point(latitude: locationDetails.latitude, longitude: locationDetails.longitude);
      var geoRef = geoFire.collection(collectionRef: collectionReference);
      documents = await geoRef.within(center: center, radius: radius, field: 'point', strictMode: true).firstWhere((element) => true);
    } else {
      // else do the normal query
      final response = await collectionReference.getDocuments();
      documents = response.documents;
    }
    return documents;
  }
}

class Shop {
  final String id;
  final String name;
  final String image;
  final LocationDetails locationDetails;
  
  Shop({
    @required this.id,
    @required this.name,
    @required this.image,
    this.locationDetails
  });
}