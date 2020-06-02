import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petty_shop/models/location.dart';

class MapScreen extends StatefulWidget {
  final LocationDetails locationDetails;
  final bool preview;
  
  MapScreen({
    this.locationDetails = const LocationDetails(latitude: 1234.0, longitude: 0.0),
    this.preview = false
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location')
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.locationDetails.latitude, widget.locationDetails.longitude),
          zoom: 16
        ),
      )
    );
  }
}