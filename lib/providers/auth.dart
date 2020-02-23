import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../constants.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiry;
  String _userId;

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    print(urlSegment);
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$FIREBASE_API_KEY';
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
    return print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}