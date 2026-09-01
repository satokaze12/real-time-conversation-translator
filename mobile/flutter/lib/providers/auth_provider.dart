import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _email;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get email => _email;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      // TODO: Call API to login
      _isAuthenticated = true;
      _email = email;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String firstName, String lastName) async {
    try {
      // TODO: Call API to register
      _isAuthenticated = true;
      _email = email;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // TODO: Call API to logout
      _isAuthenticated = false;
      _userId = null;
      _email = null;
      _token = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
