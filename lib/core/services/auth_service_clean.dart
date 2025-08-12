import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // Mock authentication system (will be replaced with Firebase later)
  bool _isSignedIn = false;
  String _userDisplayName = 'Demo User';
  String _userEmail = 'demo@girimote.com';
  String? _userPhotoUrl;

  // Getters
  bool get isSignedIn => _isSignedIn;
  String get userDisplayName => _userDisplayName;
  String get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;

  // Mock Google Sign-In
  Future<bool> signInWithGoogle() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      _isSignedIn = true;
      _userDisplayName = 'Demo User';
      _userEmail = 'demo@girimote.com';
      _userPhotoUrl = null;

      notifyListeners();
      return true;
    } catch (e) {
      print('Mock sign-in failed: $e');
      return false;
    }
  }

  // Mock Sign-Out
  Future<void> signOut() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _isSignedIn = false;
      _userDisplayName = '';
      _userEmail = '';
      _userPhotoUrl = null;

      notifyListeners();
    } catch (e) {
      print('Mock sign-out failed: $e');
    }
  }
}
