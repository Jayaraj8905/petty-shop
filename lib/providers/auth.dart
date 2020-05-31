import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';


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

  Future<void> _authenticate(String email, String password, bool isLogin) async {
    final auth = FirebaseAuth.instance;
    AuthResult authResult;

    try {
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
      }
      if(authResult.user != null) {
        handleToken(authResult.user);
        notifyListeners();
      }
    } catch (error) {
      throw(error);
    }
    
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, false);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, true);
  }
  
  Future<void> logout() async {
    _token = null;
    _expiry = null;
    _userId = null;
    notifyListeners();
    FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_timer != null) {
      _timer.cancel();
    }

    Duration duration = Duration(days: _expiry.day, hours: _expiry.hour, 
                            minutes: _expiry.hour, seconds: _expiry.second, 
                            milliseconds: _expiry.millisecond, microseconds: _expiry.microsecond);
    Timer(duration, logout);
  }

  Future<bool> tryAutoLogin() async {
    // TODO: Needs to handle using firebase instead of sharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final data = prefs.getString('userData');
    final extractedData = json.decode(data); 

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiry = DateTime.parse(extractedData['expiry']);
    notifyListeners();
    _autoLogout();
    return true;
  }

  void handleToken(FirebaseUser user) async {
    // TODO: Needs to handle using firebase instead of sharedPreferences
    IdTokenResult tokenResult = await user.getIdToken();
    _token = tokenResult.token;
    _expiry = tokenResult.expirationTime;
    _userId = user.uid;
    _autoLogout();
    // Shared the info to shared preferences
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': _token,
        'userId': _userId,
        'expiry': _expiry.toIso8601String()
      }
    );
    prefs.setString('userData', userData);
  }
}