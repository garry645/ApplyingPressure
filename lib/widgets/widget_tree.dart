import 'package:flutter/material.dart';

import '../home/home_page.dart';
import '../login/login_page.dart';
import '../services/service_provider.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    final authService = ServiceProvider.getAuthService(context);
    
    // Check current user first for immediate rendering
    final currentUser = authService.currentUser;
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // If we haven't received stream data yet, use the current user state
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (currentUser != null) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        }
        
        // Handle error state
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        
        // Handle auth states from stream
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
