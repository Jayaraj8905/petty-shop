import 'package:flutter/material.dart';

void main() => runApp(PettyShopApp());

class PettyShopApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petty Shop',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrangeAccent,
        fontFamily: 'Lato',
      ),
      home: Center(
        child: Text('Anything can start with nothing'),
      ),
    );
  }
}
