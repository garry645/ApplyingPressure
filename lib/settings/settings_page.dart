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
                      title: const Text('Common'),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          leading: const Icon(Icons.lock),
                          title: const Text('Log Out'),
                          onPressed: (context) { 
                            final authService = ServiceProvider.getAuthService(context);
                            authService.signOut(); 
                          }
                        ),
                    ],
                    ),
                ],
              ));
  }



/*
  Padding(
  padding: const EdgeInsets.all(16.0),
  child: ListView.separated(
  itemCount: 2,
  separatorBuilder: (context, index) =>
  const SizedBox(height: 10),
  itemBuilder: (context, index) {
  return Text("SOMETHING");//makeListTile(Auth().signOut(), "Logout", "logout");
  })));*/
}
