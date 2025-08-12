import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_widget_model.dart';
import '../models/device_data_model.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Real-time database references
  late DatabaseReference _devicesRef;
  late DatabaseReference _dashboardRef;

  String? _userId;

  void initialize(String userId) {
    _userId = userId;
    _devicesRef = _database.ref('users/$userId/devices');
    _dashboardRef = _database.ref('users/$userId/dashboard');
  }

  // Device Data Management
  Stream<Map<String, dynamic>> getDeviceDataStream() {
    if (_userId == null) return Stream.empty();

    return _devicesRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      return data?.cast<String, dynamic>() ?? {};
    });
  }

  Future<void> updateDeviceData(
      String deviceId, Map<String, dynamic> data) async {
    if (_userId == null) return;

    await _devicesRef.child(deviceId).update({
      ...data,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> sendCommand(
      String deviceId, String command, dynamic value) async {
    if (_userId == null) return;

    await _devicesRef.child(deviceId).child('commands').push().set({
      'command': command,
      'value': value,
      'timestamp': ServerValue.timestamp,
      'executed': false,
    });
  }

  // Dashboard Layout Management (Firestore for complex data)
  Future<void> saveDashboardLayout(List<DashboardWidgetModel> widgets) async {
    if (_userId == null) return;

    try {
      final batch = _firestore.batch();
      final layoutRef = _firestore
          .collection('users')
          .doc(_userId)
          .collection('dashboard')
          .doc('layout');

      batch.set(layoutRef, {
        'widgets': widgets.map((w) => w.toMap()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving dashboard layout: $e');
      rethrow;
    }
  }

  Stream<List<DashboardWidgetModel>> getDashboardLayoutStream() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('dashboard')
        .doc('layout')
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return <DashboardWidgetModel>[];

      final data = snapshot.data() as Map<String, dynamic>;
      final widgets = data['widgets'] as List<dynamic>? ?? [];

      return widgets
          .map((w) => DashboardWidgetModel.fromMap(w as Map<String, dynamic>))
          .toList();
    });
  }

  // User Profile Management
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    if (_userId == null) return;

    await _firestore.collection('users').doc(_userId).set({
      ...profile,
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>?> getUserProfileStream() {
    if (_userId == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(_userId)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  // Device Management
  Future<void> addDevice(
      String deviceId, Map<String, dynamic> deviceInfo) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('devices')
        .doc(deviceId)
        .set({
      ...deviceInfo,
      'createdAt': FieldValue.serverTimestamp(),
      'active': true,
    });
  }

  Stream<List<Map<String, dynamic>>> getDevicesStream() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('devices')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  void dispose() {
    // Clean up any listeners if needed
  }
}
