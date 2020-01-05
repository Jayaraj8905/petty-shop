import 'dart:math';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName ='/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(200, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(150, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1]
              )
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 8),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).errorColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Theme.of(context).errorColor,
                            offset: Offset(0, 2)
                          )
                        ]
                      ),
                      child: Text(
                        'Petty Shop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontFamily: 'Anton',
                          fontSize: 50,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }

}