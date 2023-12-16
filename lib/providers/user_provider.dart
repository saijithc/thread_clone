import 'package:flutter/material.dart';
import 'package:thread_clone/models/user_model.dart';
import 'package:thread_clone/services/auth_services.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  final AuthMethods _authMethodes = AuthMethods();
  Future<void> refreshUser() async {
    UserModel user = await _authMethodes.getCurrentUser();
    userModel = user;
    notifyListeners();
  }
}
