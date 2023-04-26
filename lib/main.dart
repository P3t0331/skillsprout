import 'package:deadline_tracker/app_root.dart';
import 'package:deadline_tracker/screens/add_subject_page.dart';
import 'package:deadline_tracker/screens/deadline_page.dart';
import 'package:deadline_tracker/screens/home_page.dart';
import 'package:deadline_tracker/screens/login_register_page.dart';
import 'package:deadline_tracker/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deadline Tracker',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)),
      home: AppRoot(),
    );
  }
}
