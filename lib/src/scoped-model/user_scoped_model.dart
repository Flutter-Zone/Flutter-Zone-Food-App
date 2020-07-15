import 'package:food_app_flutter_zone/src/enums/auth_mode.dart';
import 'package:food_app_flutter_zone/src/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserModel extends Model {
  List<User> _users = [];
  User _authenticatedUser;
  bool _isLoading = false;

  List<User> get users {
    return List.from(_users);
  }

  User get authtenticatedUser {
    return _authenticatedUser;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<bool> addUserInfo(Map<String, dynamic> userInfo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.post(
          "https://foodie2-fe2c7.firebaseio.com/users.json",
          body: json.encode(userInfo));

      final Map<String, dynamic> responseData = json.decode(response.body);

      User userWithID = User(
        id: responseData['name'],
        email: userInfo['email'],
        username: userInfo['username'],
      );

      _users.add(userWithID);
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<Map<String, dynamic>> authenticate(
      String email, String password, String username,
      {AuthMode authMode = AuthMode.SignIn}) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };

    Map<String, dynamic> userInfo = {
      "email": email,
      "username": username,
    };

    String message;
    bool hasError = false;

    try {
      http.Response response;
      if (authMode == AuthMode.SignUp) {
        response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCdiY8g2Mf11CsJC4YML8mso0Wgvlnuo6o",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
      } else if (authMode == AuthMode.SignIn) {
        response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCdiY8g2Mf11CsJC4YML8mso0Wgvlnuo6o",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
      }

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('idToken')) {
        _authenticatedUser = User(
          id: responseBody['localId'],
          email: responseBody['email'],
          token: responseBody['idToken'],
          userType: 'customer',
        );

        if (authMode == AuthMode.SignUp) {
          message = "Sign up successfully";
        } else {
          message = "Sign in successfully";
        }
      } else {
        hasError = true;
        if (responseBody['error']['message'] == 'EMAIL_EXISTS') {
          message = "Email already exists";
        } else if (responseBody['error']['message'] == "EMAIL_NOT_FOUND") {
          message = "Email does not exist";
        } else if (responseBody['error']['message'] == "INVALID_PASSWORD") {
          message = "Password is incorrect";
        }
      }

      _isLoading = false;
      notifyListeners();
      return {
        'message': message,
        'hasError': hasError,
      };
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return {
        'message': 'Failed to sign up successfully',
        'hasError': !hasError,
      };
    }
  }
}
