import 'package:flutter/material.dart';

// App Theme Colors
class AppColors {
  static const Color primary = Color(0xFF6366f1);
  static const Color primaryLight = Color(0xFFe0e7ff);
  static const Color secondary = Color(0xFF06b6d4);
  static const Color background = Color(0xFFf8fafc);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFef4444);
  static const Color success = Color(0xFF10b981);
  static const Color warning = Color(0xFFf59e0b);
  static const Color textPrimary = Color(0xFF0f172a);
  static const Color textSecondary = Color(0xFF64748b);
  static const Color border = Color(0xFFe2e8f0);
  static const Color divider = Color(0xFFf1f5f9);
}

// App Dimensions
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}

// App Strings
class AppStrings {
  static const String appName = 'Girimote';
  static const String appDescription = 'Modern IoT Dashboard App';

  // Authentication
  static const String signInWithGoogle = 'Sign in with Google';
  static const String signOut = 'Sign Out';
  static const String welcome = 'Welcome to Girimote';
  static const String signInToGetStarted =
      'Sign in to get started with your IoT dashboard';

  // Navigation
  static const String dashboard = 'Dashboard';
  static const String dashboardBuilder = 'Builder';
  static const String profile = 'Profile';

  // Dashboard Builder
  static const String addWidget = 'Add Widget';
  static const String editWidget = 'Edit Widget';
  static const String deleteWidget = 'Delete Widget';
  static const String saveLayout = 'Save Layout';
  static const String resetLayout = 'Reset Layout';

  // Widget Types
  static const String switchWidget = 'Switch';
  static const String buttonWidget = 'Button';
  static const String gaugeWidget = 'Gauge';
  static const String chartWidget = 'Chart';
  static const String indicatorWidget = 'Indicator';
  static const String textWidget = 'Text Display';

  // Error Messages
  static const String errorOccurred = 'An error occurred';
  static const String authError = 'Authentication failed';
  static const String networkError = 'Network connection failed';
}

// Widget Types Enum
enum WidgetType {
  switchWidget,
  buttonWidget,
  gaugeWidget,
  chartWidget,
  indicatorWidget,
  textWidget,
}

// Widget Size Enum
enum WidgetSize {
  small, // 1x1
  medium, // 2x1
  large, // 2x2
  wide, // 3x1
  tall, // 1x2
  extraLarge, // 3x2
}

extension WidgetSizeExtension on WidgetSize {
  Size get gridSize {
    switch (this) {
      case WidgetSize.small:
        return const Size(1, 1);
      case WidgetSize.medium:
        return const Size(2, 1);
      case WidgetSize.large:
        return const Size(2, 2);
      case WidgetSize.wide:
        return const Size(3, 1);
      case WidgetSize.tall:
        return const Size(1, 2);
      case WidgetSize.extraLarge:
        return const Size(3, 2);
    }
  }
}
