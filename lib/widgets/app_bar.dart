import 'package:applying_pressure/login/auth.dart';
import 'package:flutter/material.dart';

class APAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const APAppBar({Key? key, required this.title}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        leading: GestureDetector(
          onTap: () {
            Auth().signOut();
          },
          child: const Icon(
            Icons.settings, // add custom icons also
          ),
        ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}