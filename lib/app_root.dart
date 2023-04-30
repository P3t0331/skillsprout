import 'package:deadline_tracker/screens/persistent_navbar_page.dart';
import 'package:deadline_tracker/screens/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:deadline_tracker/services/auth.dart';
import 'package:get_it/get_it.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final _authService = GetIt.I<Auth>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PersistentBottomNavPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
