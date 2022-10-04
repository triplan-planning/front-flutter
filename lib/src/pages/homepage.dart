import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:triplan/src/models/my_page.dart';
import 'package:triplan/src/pages/group_list_view.dart';
import 'package:triplan/src/pages/login_view.dart';
import 'package:triplan/src/pages/user_list_view.dart';
import 'package:triplan/src/pages/welcome_view.dart';
import 'package:triplan/src/settings/settings_view.dart';

/// Displays detailed information about a User.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  static final List<MyPage> _pages = <MyPage>[
    MyPage(
      widget: const WelcomeView(),
      title: "home",
      icon: const Icon(Icons.home),
    ),
    MyPage(
      widget: const UserListView(enableUserCreation: true),
      title: "users",
      icon: const Icon(Icons.person),
    ),
    MyPage(
      widget: const GroupListView(),
      title: "groups",
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

    return Scaffold(
      appBar: AppBar(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(selectedPage.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Routemaster.of(context).push(FakeLoginView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Routemaster.of(context).push(SettingsView.routeName);
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
    );
  }
}
