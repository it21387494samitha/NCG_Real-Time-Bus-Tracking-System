// features/profile/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _SettingsSection(
            title: 'Profile',
            children: [
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: const Text(
                  'John Driver',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Bus #1234'),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onTap: () {
                  // Navigate to profile edit
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // App Settings
          _SettingsSection(
            title: 'App Settings',
            children: [
              _SettingItem(
                icon: Icons.color_lens_outlined,
                title: 'Theme',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.light_mode,
                        color: themeState.themeMode == ThemeModeType.light
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      onPressed: () => themeNotifier.setTheme(ThemeModeType.light),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.dark_mode,
                        color: themeState.themeMode == ThemeModeType.dark
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      onPressed: () => themeNotifier.setTheme(ThemeModeType.dark),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings_suggest_outlined,
                        color: themeState.themeMode == ThemeModeType.system
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      onPressed: () => themeNotifier.setTheme(ThemeModeType.system),
                    ),
                  ],
                ),
              ),
              _SettingItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              _SettingItem(
                icon: Icons.location_on_outlined,
                title: 'Location Accuracy',
                subtitle: 'High accuracy for better tracking',
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onTap: () {
                  // Show location accuracy options
                },
              ),
              _SettingItem(
                icon: Icons.wifi_tethering_outlined,
                title: 'Offline Mode',
                subtitle: 'Sync when reconnected',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // About & Support
          _SettingsSection(
            title: 'About & Support',
            children: [
              _SettingItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
              _SettingItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _SettingItem(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
              _SettingItem(
                icon: Icons.info_outline,
                title: 'App Version',
                trailing: Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle logout
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}