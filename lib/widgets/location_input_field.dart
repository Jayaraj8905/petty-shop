import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:petty_shop/models/location.dart';
import 'package:petty_shop/screens/map_screen.dart';
import './../helpers/location_helper.dart';

class LocationInputField extends StatefulWidget {
  LocationInputField({Key key}) : super(key: key);

  @override
  _LocationInputFieldState createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  String _locationUrl;
  Future<void> _getCurrentLocation() async {
    final locationData = await Location().getLocation();
    final staticUrl = LocationHelper.generateLocationPreviewImage(latitude: locationData.latitude, longitude: locationData.longitude);
    setState(() {
      _locationUrl = staticUrl;
    });
  } 

  Future<void> _pickLocation() async {
    final currentLocation = await Location().getLocation();
    final locationDetails = LocationDetails(latitude: currentLocation.latitude, longitude: currentLocation.longitude);
    final locationData = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(locationDetails: locationDetails,preview: true)
      )
    );
    final staticUrl = LocationHelper.generateLocationPreviewImage(latitude: locationData.latitude, longitude: locationData.longitude);
    setState(() {
      _locationUrl = staticUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey)
          ),
          alignment: Alignment.center,
          child: _locationUrl == null
                  ? Text(
                      'No location chosen',
                      textAlign: TextAlign.center,
                    )
                  : Image.network(
                    _locationUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentLocation, 
              icon: Icon(Icons.location_on), 
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _pickLocation, 
              icon: Icon(Icons.map), 
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
            )
          ],
        )
      ],
    );
  }
}