import 'package:applying_pressure/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../services/service_provider.dart';
import '../services/interfaces/auth_service_interface.dart';

class SettingsPage extends StatelessWidget {
  final String title = "Settings";

  const SettingsPage({Key? key}) : super(key: key);

  static const routeName = '/settingsPage';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SettingsList(
                sections: [
                    SettingsSection(
                      title: const Text('User Information'),
                      tiles: <SettingsTile>[
                        SettingsTile(
                          leading: const Icon(Icons.person),
                          title: const Text('User'),
                          value: _buildUserInfo(context),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: const Text('Common'),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          leading: const Icon(Icons.lock),
                          title: const Text('Log Out'),
                          onPressed: (context) async { 
                            final authService = ServiceProvider.getAuthService(context);
                            await authService.signOut();
                            
                            // Navigate to root and remove all routes from stack
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', 
                                (route) => false,
                              );
                            }
                          }
                        ),
                    ],
                    ),
                ],
              ));
  }

  Widget _buildUserInfo(BuildContext context) {
    final authService = ServiceProvider.getAuthService(context);
    final user = authService.currentUser;
    
    if (user?.email != null) {
      return Text(
        user!.email!,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      );
    }
    
    return const Text(
      'Not logged in',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    );
  }
}
