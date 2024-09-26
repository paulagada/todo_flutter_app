import 'package:flutter/material.dart';
import 'package:todo_app/screens/AuthScreens/auth_navigation.dart';
import 'package:todo_app/services/model/user.dart';
import 'package:todo_app/util/api.dart';
import 'package:todo_app/util/storage.dart';

class AuthProvider with  Api, AppStorage, ChangeNotifier {
  bool _loggedIn = false;
  User? user;

  bool get authenticated => _loggedIn;

  Future<Map<String, dynamic>> loginUser(
    Map<String, dynamic> payload,
  ) async {
    var response = await httpClient.post(
      "/auth/login",
      data: payload,
    );
    if(response.data['message'] != "success") {
      return Map<String, dynamic>.from(response.data);
    } else {
      _loggedIn = true;
      user = User.fromJson(response.data['user']);
      notifyListeners();
      return Map<String, dynamic>.from(response.data);
    }

  }

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> payload,
      ) async {
    var response = await httpClient.post(
      "/auth/register",
      data: payload,
    );
    _loggedIn = true;
    user = User.fromJson(response.data['user']);
    notifyListeners();
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> sendOtp(
      Map<String, dynamic> payload,
      ) async {
    var response = await httpClient.post(
      "/auth/send-otp",
      data: payload,
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> verifyEmail(
      Map<String, dynamic> payload,
      ) async {
    var response = await httpClient.post(
      "/auth/verify-otp",
      data: payload,
    );
    _loggedIn = true;
    user = User.fromJson(response.data['user']);
    notifyListeners();
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> sendResetOtp(
      Map<String, dynamic> payload,
      ) async {
    var response = await httpClient.post(
      "/auth/password/send-otp",
      data: payload,
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> resetPassword(
      Map<String, dynamic> payload,
      ) async {
    var response = await httpClient.post(
      "/auth/password/verify-otp",
      data: payload,
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> logoutUser(BuildContext context) async {
    await removeStorageItem('token');
    _loggedIn = false;
    user = User();
    Navigator.pushReplacementNamed(context, AuthNavigation.path);
  }
}
