import 'package:flutter/material.dart';
import 'package:triplan/src/models/my_page.dart';
import 'package:triplan/src/pages/trip_list_view.dart';
import 'package:triplan/src/pages/user_list_view.dart';
import 'package:triplan/src/pages/welcome_view.dart';
import 'package:triplan/src/settings/settings_view.dart';

/// Displays detailed information about a User.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<MyPage> _pages = <MyPage>[
    MyPage(
        widget: const WelcomeView(),
        title: "home",
        icon: const Icon(Icons.home)),
    MyPage(
        widget: const UserListView(),
        title: "users",
        icon: const Icon(Icons.person)),
    MyPage(
        widget: const TripListView(),
        title: "trips",
        icon: const Icon(Icons.flight)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages.elementAt(_selectedIndex).title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex).widget,
      bottomNavigationBar: BottomNavigationBar(
        items: _pages
            .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.title))
            .toList(),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue[900],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
