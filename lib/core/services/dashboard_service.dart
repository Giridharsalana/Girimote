import 'package:flutter/material.dart';
import '../models/dashboard_widget_model.dart';
import '../constants/app_constants.dart';

class DashboardService extends ChangeNotifier {
  List<DashboardWidgetModel> _widgets = [];
  bool _isEditMode = false;

  List<DashboardWidgetModel> get widgets => _widgets;
  bool get isEditMode => _isEditMode;

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  void addWidget(DashboardWidgetModel widget) {
    _widgets.add(widget);
    notifyListeners();
  }

  void removeWidget(String widgetId) {
    _widgets.removeWhere((widget) => widget.id == widgetId);
    notifyListeners();
  }

  void updateWidget(DashboardWidgetModel updatedWidget) {
    final index =
        _widgets.indexWhere((widget) => widget.id == updatedWidget.id);
    if (index != -1) {
      _widgets[index] = updatedWidget;
      notifyListeners();
    }
  }

  void reorderWidgets(List<DashboardWidgetModel> newOrder) {
    _widgets = newOrder;
    notifyListeners();
  }

  void moveWidget(String widgetId, int newIndex) {
    final widget = getWidgetById(widgetId);
    if (widget != null) {
      _widgets.remove(widget);
      if (newIndex > _widgets.length) {
        _widgets.add(widget);
      } else {
        _widgets.insert(newIndex, widget);
      }
      notifyListeners();
    }
  }

  void loadDefaultWidgets() {
    _widgets = [
      DashboardWidgetModel(
        id: 'switch_1',
        title: 'Living Room Light',
        type: WidgetType.switchWidget,
        size: WidgetSize.medium, // 2x1 for better visibility with smaller cells
        x: 0,
        y: 0,
        data: {'value': false},
        settings: {'deviceId': 'device_001'},
      ),
      DashboardWidgetModel(
        id: 'gauge_1',
        title: 'Temperature',
        type: WidgetType.gaugeWidget,
        size: WidgetSize.extraLarge, // 3x2 for good visibility
        x: 3,
        y: 0,
        data: {'value': 22.5, 'unit': '°C'},
        settings: {'deviceId': 'device_002', 'min': 0, 'max': 50},
      ),
      DashboardWidgetModel(
        id: 'button_1',
        title: 'Garage Door',
        type: WidgetType.buttonWidget,
        size: WidgetSize.medium, // 2x1
        x: 0,
        y: 2,
        data: {'value': 'OPEN'},
        settings: {'deviceId': 'device_003', 'action': 'toggle'},
      ),
      DashboardWidgetModel(
        id: 'chart_1',
        title: 'Power Usage',
        type: WidgetType.chartWidget,
        size: WidgetSize.extraLarge, // 3x2
        x: 7,
        y: 0,
        data: {
          'values': [10, 15, 12, 18, 25, 20, 22],
          'labels': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        },
        settings: {'deviceId': 'device_004', 'unit': 'kW'},
      ),
    ];
    notifyListeners();
  }

  void clearAllWidgets() {
    _widgets.clear();
    notifyListeners();
  }

  List<DashboardWidgetModel> getWidgetsByType(WidgetType type) {
    return _widgets.where((widget) => widget.type == type).toList();
  }

  DashboardWidgetModel? getWidgetById(String id) {
    try {
      return _widgets.firstWhere((widget) => widget.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateWidgetData(String widgetId, Map<String, dynamic> newData) {
    final widget = getWidgetById(widgetId);
    if (widget != null) {
      final updatedWidget = widget.copyWith(data: newData);
      updateWidget(updatedWidget);
    }
  }

  void updateWidgetSize(String widgetId, WidgetSize newSize) {
    final widget = getWidgetById(widgetId);
    if (widget != null) {
      final updatedWidget = widget.copyWith(size: newSize);
      updateWidget(updatedWidget);
    }
  }

  void resizeWidgetByDimensions(String widgetId, int newWidth, int newHeight,
      int gridColumns, int gridRows) {
    final widget = getWidgetById(widgetId);
    if (widget == null) return;

    // Find the closest WidgetSize that matches the dimensions
    WidgetSize? newSize;
    for (final size in WidgetSize.values) {
      final gridSize = size.gridSize;
      if (gridSize.width.toInt() == newWidth &&
          gridSize.height.toInt() == newHeight) {
        newSize = size;
        break;
      }
    }

    // If no exact match, find the closest one or create a custom size logic
    if (newSize == null) {
      // For now, use the closest standard size
      if (newWidth == 1 && newHeight == 1)
        newSize = WidgetSize.small;
      else if (newWidth == 2 && newHeight == 1)
        newSize = WidgetSize.medium;
      else if (newWidth == 2 && newHeight == 2)
        newSize = WidgetSize.large;
      else if (newWidth == 3 && newHeight == 1)
        newSize = WidgetSize.wide;
      else if (newWidth == 1 && newHeight == 2)
        newSize = WidgetSize.tall;
      else if (newWidth == 3 && newHeight == 2)
        newSize = WidgetSize.extraLarge;
      else
        newSize = WidgetSize.large; // Default fallback
    }

    if (canResizeWidget(widgetId, newSize, gridColumns, gridRows)) {
      updateWidgetSize(widgetId, newSize);
    }
  }

  void updateWidgetPosition(String widgetId, int newX, int newY) {
    final widget = getWidgetById(widgetId);
    if (widget != null) {
      final updatedWidget = widget.copyWith(x: newX, y: newY);
      updateWidget(updatedWidget);
    }
  }

  // Validation methods
  bool canPlaceWidget(DashboardWidgetModel widget, int x, int y,
      int gridColumns, int gridRows) {
    final size = widget.size.gridSize;

    // Check if widget fits within grid bounds
    if (x < 0 ||
        y < 0 ||
        x + size.width > gridColumns ||
        y + size.height > gridRows) {
      return false;
    }

    // Check for collisions with other widgets
    for (final otherWidget in _widgets) {
      if (otherWidget.id == widget.id) continue; // Skip self

      final otherSize = otherWidget.size.gridSize;
      if (_widgetsOverlap(
        x,
        y,
        size.width.toInt(),
        size.height.toInt(),
        otherWidget.x,
        otherWidget.y,
        otherSize.width.toInt(),
        otherSize.height.toInt(),
      )) {
        return false;
      }
    }

    return true;
  }

  bool canResizeWidget(
      String widgetId, WidgetSize newSize, int gridColumns, int gridRows) {
    final widget = getWidgetById(widgetId);
    if (widget == null) return false;

    final size = newSize.gridSize;

    // Check if resized widget fits within grid bounds
    if (widget.x + size.width > gridColumns ||
        widget.y + size.height > gridRows) {
      return false;
    }

    // Check minimum size constraints
    if (size.width < 1 || size.height < 1) {
      return false;
    }

    // Check for collisions with other widgets
    for (final otherWidget in _widgets) {
      if (otherWidget.id == widget.id) continue; // Skip self

      final otherSize = otherWidget.size.gridSize;
      if (_widgetsOverlap(
        widget.x,
        widget.y,
        size.width.toInt(),
        size.height.toInt(),
        otherWidget.x,
        otherWidget.y,
        otherSize.width.toInt(),
        otherSize.height.toInt(),
      )) {
        return false;
      }
    }

    return true;
  }

  bool _widgetsOverlap(
      int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
    return !(x1 >= x2 + w2 || x2 >= x1 + w1 || y1 >= y2 + h2 || y2 >= y1 + h1);
  }

  // Predefined widget templates
  List<Map<String, dynamic>> get widgetTemplates => [
        {
          'type': WidgetType.switchWidget,
          'title': 'Switch',
          'description': 'Toggle switch for on/off control',
          'icon': Icons.toggle_on,
          'defaultSize': WidgetSize.small,
        },
        {
          'type': WidgetType.buttonWidget,
          'title': 'Button',
          'description': 'Action button for commands',
          'icon': Icons.smart_button,
          'defaultSize': WidgetSize.medium,
        },
        {
          'type': WidgetType.gaugeWidget,
          'title': 'Gauge',
          'description': 'Circular gauge for sensor values',
          'icon': Icons.speed,
          'defaultSize': WidgetSize.large,
        },
        {
          'type': WidgetType.chartWidget,
          'title': 'Chart',
          'description': 'Line chart for time series data',
          'icon': Icons.show_chart,
          'defaultSize': WidgetSize.extraLarge,
        },
        {
          'type': WidgetType.indicatorWidget,
          'title': 'Indicator',
          'description': 'Status indicator light',
          'icon': Icons.circle,
          'defaultSize': WidgetSize.small,
        },
        {
          'type': WidgetType.textWidget,
          'title': 'Text Display',
          'description': 'Display text values',
          'icon': Icons.text_fields,
          'defaultSize': WidgetSize.medium,
        },
      ];
}
