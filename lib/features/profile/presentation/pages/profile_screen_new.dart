import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/auth_service.dart';

class ProfileScreenNew extends StatelessWidget {
  const ProfileScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(context, authService),

                const SizedBox(height: AppDimensions.paddingXLarge),

                // Profile Options
                _buildProfileOptions(context, authService),

                const SizedBox(height: AppDimensions.paddingXLarge),

                // App Information
                _buildAppInfo(context),

                const SizedBox(height: AppDimensions.paddingXLarge),

                // Sign Out Button
                _buildSignOutButton(context, authService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthService authService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: authService.userPhotoUrl != null
                  ? NetworkImage(authService.userPhotoUrl!)
                  : null,
              child: authService.userPhotoUrl == null
                  ? Text(
                      authService.userDisplayName.isNotEmpty
                          ? authService.userDisplayName[0].toUpperCase()
                          : 'U',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    )
                  : null,
            ),

            const SizedBox(height: AppDimensions.paddingMedium),

            // User Name
            Text(
              authService.userDisplayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: AppDimensions.paddingSmall),

            // User Email
            Text(
              authService.userEmail,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),

            const SizedBox(height: AppDimensions.paddingMedium),

            // Demo Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Text(
                'Demo Account',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, AuthService authService) {
    return Card(
      child: Column(
        children: [
          _buildOptionTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            subtitle: 'Manage your privacy settings',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            icon: Icons.devices_outlined,
            title: 'Connected Devices',
            subtitle: 'Manage your IoT devices',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            icon: Icons.backup_outlined,
            title: 'Backup & Sync',
            subtitle: 'Backup your dashboard layout',
            onTap: () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildOptionTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and support',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            icon: Icons.info_outline,
            title: 'About Girimote',
            subtitle: 'Version 1.0.0',
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            icon: Icons.star_outline,
            title: 'Rate App',
            subtitle: 'Rate us on the app store',
            onTap: () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: AppDimensions.iconMedium,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSignOutButton(BuildContext context, AuthService authService) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showSignOutDialog(context, authService),
        icon: const Icon(Icons.logout),
        label: const Text(AppStrings.signOut),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingMedium,
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content:
            const Text('This feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: const Icon(
          Icons.router,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: [
        const Text(AppStrings.appDescription),
        const SizedBox(height: 16),
        const Text(
            'Built with Flutter and Firebase for seamless IoT device management.'),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authService.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
