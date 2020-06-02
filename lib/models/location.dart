import 'package:flutter/foundation.dart';

class LocationDetails {
  final double latitude;
  final double longitude;
  final String address;
  const LocationDetails({
    @required this.latitude,
    @required this.longitude,
    this.address
  });
}