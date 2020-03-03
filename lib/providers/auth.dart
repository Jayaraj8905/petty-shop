import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petty_shop/models/http_exception.dart';
import 'dart:convert';
import './../constants.dart';


// Reference: https://firebase.google.com/docs/reference/rest/auth
class Auth with ChangeNotifier {
  String _token;
  DateTime _expiry;
  String _userId;
  Timer _timer;

  bool get isAuthenticated {
    return _token != null;
  }

  String get token {
    if (_expiry != null && _expiry.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$FIREBASE_API_KEY';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email':  email,
            'password': password,
            'returnSecureToken': true
          }
        )
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw new HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiry = DateTime.now().add(
        Duration(seconds: int.parse(
          responseData['expiresIn']
        ))
      );
      _autoLogout();
      notifyListeners();
    } catch(error) {
      throw error;
    }
    
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
  
  void logout() {
    _token = null;
    _expiry = null;
    _userId = null;
    notifyListeners();
  }

  void _autoLogout() {
    if (_timer != null) {
      _timer.cancel();
    }

    Duration duration = _expiry.difference(DateTime.now());
    Timer(duration, logout);
  }
}