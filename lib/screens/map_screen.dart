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
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check), 
            onPressed: _pickedLocation != null 
                      ? () {
                              Navigator.of(context).pop(_pickedLocation);
                            }
                      : null
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.locationDetails.latitude, widget.locationDetails.longitude),
          zoom: 16,
        ),
        onTap: _selectLocation,
        markers: _pickedLocation == null
                ? null
                : {
                    Marker(
                      markerId: MarkerId('m1'),
                      position: _pickedLocation
                    )}
      )
    );
  }
}