import 'package:applying_pressure/settings/settings_page.dart';
import 'package:flutter/material.dart';

class APAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const APAppBar({Key? key, required this.title}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(title),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              //Navigator.push(context, SettingsPage.routeName);
            },
            child: const Icon(
              Icons.settings, // add custom icons also
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
