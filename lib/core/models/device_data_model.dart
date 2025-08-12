class DeviceDataModel {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final Map<String, dynamic> data;
  final DateTime lastUpdated;
  final bool isOnline;

  DeviceDataModel({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.data,
    required this.lastUpdated,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'data': data,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'isOnline': isOnline,
    };
  }

  factory DeviceDataModel.fromMap(Map<String, dynamic> map) {
    return DeviceDataModel(
      deviceId: map['deviceId'] ?? '',
      deviceName: map['deviceName'] ?? '',
      deviceType: map['deviceType'] ?? '',
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        map['lastUpdated'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isOnline: map['isOnline'] ?? false,
    );
  }

  DeviceDataModel copyWith({
    String? deviceId,
    String? deviceName,
    String? deviceType,
    Map<String, dynamic>? data,
    DateTime? lastUpdated,
    bool? isOnline,
  }) {
    return DeviceDataModel(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      data: data ?? this.data,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  // Helper methods for common device operations
  T? getValue<T>(String key) {
    return data[key] as T?;
  }

  bool getBoolValue(String key, {bool defaultValue = false}) {
    return data[key] as bool? ?? defaultValue;
  }

  double getDoubleValue(String key, {double defaultValue = 0.0}) {
    final value = data[key];
    if (value is int) return value.toDouble();
    return value as double? ?? defaultValue;
  }

  int getIntValue(String key, {int defaultValue = 0}) {
    final value = data[key];
    if (value is double) return value.toInt();
    return value as int? ?? defaultValue;
  }

  String getStringValue(String key, {String defaultValue = ''}) {
    return data[key] as String? ?? defaultValue;
  }
}
