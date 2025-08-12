import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/main/presentation/pages/main_navigation_screen.dart';

class GirimoteApp extends StatelessWidget {
  const GirimoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          return authService.isSignedIn
              ? const MainNavigationScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
