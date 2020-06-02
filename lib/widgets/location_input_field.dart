import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:petty_shop/models/location.dart';
import 'package:petty_shop/screens/map_screen.dart';
import './../helpers/location_helper.dart';

class LocationInputField extends FormField<LocationDetails> {
  LocationInputField({
    FormFieldSetter<LocationDetails> onSaved,
    FormFieldValidator<LocationDetails> validator,
    LocationDetails initialValue,
    bool autovalidate = false
  }): super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autovalidate,
    builder: (FormFieldState<LocationDetails> state) {
      Future<void> _getCurrentLocation() async {
        final locationData = await Location().getLocation();
        final locationDetails = LocationDetails(latitude: locationData.latitude, longitude: locationData.longitude);
        state.didChange(locationDetails);
      } 

      Future<void> _pickLocation() async {
        final currentLocation = await Location().getLocation();
        final defLocation = LocationDetails(latitude: currentLocation.latitude, longitude: currentLocation.longitude);
        final pickedLocation = await Navigator.of(state.context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(locationDetails: defLocation,preview: true)
          )
        );
        final locationDetails = LocationDetails(latitude: pickedLocation.latitude, longitude: pickedLocation.longitude);
        state.didChange(locationDetails);
      }
      return Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey)
            ),
            alignment: Alignment.center,
            child: state.value == null
                  ? Text(
                      'No location chosen',
                      textAlign: TextAlign.center,
                    )
                  : Image.network(
                    LocationHelper.generateLocationPreviewImage(latitude: state.value.latitude, longitude: state.value.longitude),
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
                textColor: Theme.of(state.context).primaryColor,
              ),
              FlatButton.icon(
                onPressed: _pickLocation, 
                icon: Icon(Icons.map), 
                label: Text('Select on Map'),
                textColor: Theme.of(state.context).primaryColor,
              )
            ],
          ),
        ],
      );
    }
  );
}