import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petty_shop/widgets/image_input_field.dart';

class ShopAddScreen extends StatefulWidget {
  static const routeName ='/auth';
  ShopAddScreen({Key key}) : super(key: key);

  @override
  _ShopAddScreenState createState() => _ShopAddScreenState();
}

class _ShopAddScreenState extends State<ShopAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Map<String, dynamic> _formData = {
    'shopname': null,
    'image': null
  };

  void _onSave(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_formData);
      // TODO: Save the data to firebase
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Shop has been Added'), 
          duration: Duration(seconds: 2)
        ));
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add your shop')
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Shop Name'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Invalid shop name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['shopname'] = value;
                        },
                      ),
                      ImageInputField(
                        validator: (File file) {
                          if (file == null) {
                            return 'Capture the image';
                          }
                          return null;
                        },
                        onSaved: (File file) {
                          _formData['image'] = file;
                        }
                      ),
                      RaisedButton(
                        child: Text('Save'),
                        onPressed: () => _onSave(context),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.button.color,
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}