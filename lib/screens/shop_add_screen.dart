import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petty_shop/models/location.dart';
import 'package:petty_shop/providers/shops.dart';
import 'package:petty_shop/screens/shop_list_screen.dart';
import 'package:petty_shop/widgets/location_input_field.dart';
import 'package:provider/provider.dart';
import 'package:petty_shop/widgets/image_input_field.dart';

class ShopAddScreen extends StatefulWidget {
  static const routeName ='/shop-add';
  ShopAddScreen({Key key}) : super(key: key);

  @override
  _ShopAddScreenState createState() => _ShopAddScreenState();
}

class _ShopAddScreenState extends State<ShopAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isCreating = false;

  Map<String, dynamic> _formData = {
    'shopname': null,
    'image': null
  };

  void _onSave(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isCreating = true;
      });
      _formKey.currentState.save();
      await Provider.of<Shops>(context, listen: false)
        .addShop(_formData['shopname'], _formData['image'], _formData['locationDetails']);
      // _scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text('Shop has been Added asdfasda'), 
      //     duration: Duration(seconds: 2)
      //   ));
      Navigator.of(context).pop();
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add your shop'),
        actions: <Widget>[
          if (_isCreating)
            CircularProgressIndicator()
          else
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _onSave(context),
            )
        ],
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
                      SizedBox(
                        height: 20,
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
                      SizedBox(
                        height: 20,
                      ),
                      LocationInputField(
                        validator: (LocationDetails details) {
                          if (details == null) {
                            return 'Select the Location';
                          }
                          return null;
                        },
                        onSaved: (LocationDetails locationDetails) {
                          _formData['locationDetails'] = locationDetails;
                        }
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