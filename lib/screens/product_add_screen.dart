import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petty_shop/providers/products.dart';
import 'package:petty_shop/widgets/image_input_field.dart';
import 'package:provider/provider.dart';

class ProductAddScreen extends StatefulWidget {
  static const routeName ='/product-add';
  ProductAddScreen({Key key}) : super(key: key);

  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isCreating = false;

  Map<String, dynamic> _formData = {
    'productname': null,
    'image': null
  };

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isCreating = true;
      });
      _formKey.currentState.save();
      // await Provider.of<Products>(context, listen: false).addProduct();
      print(_formData);
      Navigator.of(context).pop();
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add your product'),
        actions: <Widget>[
          if (_isCreating)
            CircularProgressIndicator()
          else
            IconButton(
              icon: Icon(Icons.save),
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
                          labelText: 'Product Name'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Invalid Product name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['productname'] = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // TODO: ENHANCE TO PARSE THE URL FROM HTTP
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