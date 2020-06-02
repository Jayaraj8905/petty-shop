import 'package:flutter/foundation.dart';

class Location {
  final double latitude;
  final double longitude;
  final String address;
  const Location({
    @required this.latitude,
    @required this.longitude,
    this.address
  });
}