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
    final timestamp = DateTime.now();
    final GeoFirePoint geoFirePoint = geoFire.point(latitude: locationDetails.latitude, longitude: locationDetails.longitude);
    try {
      final response = await Firestore.instance.collection('shops').add({
        "name": name,
        "createDate": timestamp.toIso8601String(),
        "userId": userId,
        "point": geoFirePoint.data
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
      _list.insert(0, new Shop(id: response.documentID, name: name, image: url, locationDetails: locationDetails));
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

      List<DocumentSnapshot> documents;
      Query collectionReference = Firestore.instance.collection('shops').reference();
      // collectionReference = collectionReference.where('userId', isEqualTo: userId);
      // collectionReference = collectionReference.limit(1);
      
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
  final LocationDetails locationDetails;
  
  Shop({
    @required this.id,
    @required this.name,
    @required this.image,
    this.locationDetails
  });
}