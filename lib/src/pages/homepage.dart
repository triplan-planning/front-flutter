import 'package:flutter/material.dart';
import 'package:triplan/src/forms/create_user_form.dart';
import 'package:triplan/src/models/my_page.dart';
import 'package:triplan/src/pages/trip_list_view.dart';
import 'package:triplan/src/pages/user_detail_view.dart';
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
      icon: const Icon(Icons.home),
    ),
    MyPage(
      widget: const UserListView(),
      title: "users",
      icon: const Icon(Icons.person),
    ),
    MyPage(
      widget: const TripListView(),
      title: "trips",
      icon: const Icon(Icons.flight),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyPage selectedPage = _pages.elementAt(_selectedIndex);
    FloatingActionButton? newButton;
    switch (selectedPage.title) {
      case "users":
        newButton = FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, CreateUserForm.routeName);
          },
          child: const Icon(Icons.add),
        );
        break;
      default:
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPage.title),
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
      body: selectedPage.widget,
      bottomNavigationBar: BottomNavigationBar(
        items: _pages
            .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.title))
            .toList(),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue[800],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: newButton,
    );
  }
}
