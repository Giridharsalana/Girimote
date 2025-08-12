import '../constants/app_constants.dart';

class DashboardWidgetModel {
  final String id;
  final String title;
  final WidgetType type;
  final WidgetSize size;
  final int x;
  final int y;
  final Map<String, dynamic> data;
  final Map<String, dynamic> settings;

  DashboardWidgetModel({
    required this.id,
    required this.title,
    required this.type,
    required this.size,
    required this.x,
    required this.y,
    required this.data,
    required this.settings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.toString().split('.').last,
      'size': size.toString().split('.').last,
      'x': x,
      'y': y,
      'data': data,
      'settings': settings,
    };
  }

  factory DashboardWidgetModel.fromMap(Map<String, dynamic> map) {
    return DashboardWidgetModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: _parseWidgetType(map['type']),
      size: _parseWidgetSize(map['size']),
      x: map['x'] ?? 0,
      y: map['y'] ?? 0,
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }

  static WidgetType _parseWidgetType(String? typeString) {
    switch (typeString) {
      case 'switchWidget':
        return WidgetType.switchWidget;
      case 'buttonWidget':
        return WidgetType.buttonWidget;
      case 'gaugeWidget':
        return WidgetType.gaugeWidget;
      case 'chartWidget':
        return WidgetType.chartWidget;
      case 'indicatorWidget':
        return WidgetType.indicatorWidget;
      case 'textWidget':
        return WidgetType.textWidget;
      default:
        return WidgetType.textWidget;
    }
  }

  static WidgetSize _parseWidgetSize(String? sizeString) {
    switch (sizeString) {
      case 'small':
        return WidgetSize.small;
      case 'medium':
        return WidgetSize.medium;
      case 'large':
        return WidgetSize.large;
      case 'wide':
        return WidgetSize.wide;
      case 'tall':
        return WidgetSize.tall;
      case 'extraLarge':
        return WidgetSize.extraLarge;
      default:
        return WidgetSize.small;
    }
  }

  DashboardWidgetModel copyWith({
    String? id,
    String? title,
    WidgetType? type,
    WidgetSize? size,
    int? x,
    int? y,
    Map<String, dynamic>? data,
    Map<String, dynamic>? settings,
  }) {
    return DashboardWidgetModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      size: size ?? this.size,
      x: x ?? this.x,
      y: y ?? this.y,
      data: data ?? this.data,
      settings: settings ?? this.settings,
    );
  }
}
