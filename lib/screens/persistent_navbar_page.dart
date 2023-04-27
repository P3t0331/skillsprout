import 'package:deadline_tracker/screens/search_deadlines_page.dart';
import 'package:deadline_tracker/screens/settings_page.dart';
import 'package:flutter/material.dart';

import '../models/persistent_tab_item.dart';
import '../widgets/persistent_bottombar_scaffold.dart';
import 'home_page.dart';

class PersistentBottomNavPage extends StatelessWidget {
  final _homeNavigatorKey = GlobalKey<NavigatorState>();
  final _deadlinesNavigatorKey = GlobalKey<NavigatorState>();
  final _settingsNavigatorKey = GlobalKey<NavigatorState>();

  PersistentBottomNavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: HomePage(),
          icon: Icons.home,
          title: 'Home',
          navigatorkey: _homeNavigatorKey,
        ),
        PersistentTabItem(
          tab: SearchDeadlinesPage(),
          icon: Icons.content_paste_sharp,
          title: 'Deadlines',
          navigatorkey: _deadlinesNavigatorKey,
        ),
        PersistentTabItem(
          tab: SettingsPage(),
          icon: Icons.settings,
          title: 'Settings',
          navigatorkey: _settingsNavigatorKey,
        ),
      ],
    );
  }
}
