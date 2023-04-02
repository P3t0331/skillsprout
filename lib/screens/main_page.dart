import 'package:deadline_tracker/screens/home_page.dart';
import 'package:deadline_tracker/screens/settings_page.dart';
import 'package:deadline_tracker/screens/deadline_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    DeadlinePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TaskMate"),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.content_paste_sharp), label: 'Deadlines'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
