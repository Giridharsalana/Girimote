import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // For now, let's create a simple mock authentication system
  // This will be replaced with proper Google Sign-In once we fix the dependencies

  bool _isSignedIn = false;
  String _userDisplayName = 'Demo User';
  String _userEmail = 'demo@girimote.com';
  String? _userPhotoUrl;

  bool get isMockSignedIn => _isSignedIn;

  // Mock Google Sign-In (temporary)
  Future<bool> signInWithGoogleMock() async {
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
      debugPrint('Mock Google Sign-In Error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      if (isAuthenticated) {
        await _auth.signOut();
      }
      _isSignedIn = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
      _isSignedIn = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting account: $e');
      return false;
    }
  }

  // Get user display name
  String get userDisplayName {
    if (isAuthenticated) {
      return _auth.currentUser?.displayName ?? 'User';
    }
    return _isSignedIn ? _userDisplayName : 'Guest';
  }

  // Get user email
  String get userEmail {
    if (isAuthenticated) {
      return _auth.currentUser?.email ?? '';
    }
    return _isSignedIn ? _userEmail : '';
  }

  // Get user photo URL
  String? get userPhotoUrl {
    if (isAuthenticated) {
      return _auth.currentUser?.photoURL;
    }
    return _isSignedIn ? _userPhotoUrl : null;
  }

  // Check if user is signed in (either Firebase or mock)
  bool get isSignedIn => isAuthenticated || _isSignedIn;
}
