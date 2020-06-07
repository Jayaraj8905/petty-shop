import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petty_shop/providers/products.dart';
import 'package:petty_shop/providers/shops.dart';
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
    'name': null,
    'image': null,
    'shopId': null,
    'price': null,
    'description': null
  };

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isCreating = true;
      });
      _formKey.currentState.save();
      // await Provider.of<Products>(context, listen: false).addProduct();

      await Provider.of<Products>(context, listen: false).addShopProduct(
        _formData['shopId'],
        name: _formData['name'],
        description: _formData['description'],
        price: _formData['price'],
        image: _formData['image']
      );
      Navigator.of(context).pop();
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments as String;
    final Shop shop = Provider.of<Shops>(context, listen: false).findById(shopId);
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add product'),
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
                          labelText: 'Name'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Invalid Product name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['name'] = value;
                          _formData['shopId'] = shop.id;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Invalid Product description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['description'] = value;
                        }
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price'
                        ),
                        validator: (value) {
                          if (value.isEmpty || double.tryParse(value) == null) {
                            return 'Invalid Price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter price greater than 0';
                          }  
                          return null;
                        },
                        onSaved: (value) {
                          _formData['price'] = double.tryParse(value);
                        }
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