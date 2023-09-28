import 'package:acrogate/views/Screens/BottomNav/History.dart';
import 'package:acrogate/views/Screens/BottomNav/Homepage.dart';
import 'package:acrogate/views/Screens/BottomNav/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../constants.dart';

class UserBottomBar extends StatefulWidget {
  static var routeName = '/user-bottom-nav';

  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        hideNavigationBarWhenKeyboardShows: true,
        resizeToAvoidBottomInset: true,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [const HomePage(), const History(), const Profile()];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(FeatherIcons.home),
      title: ("Home"),
      activeColorPrimary: kprimaryColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.doorbell_outlined),
      title: ("Entries"),
      activeColorPrimary: kprimaryColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person_4_outlined),
      title: ("Profile"),
      activeColorPrimary: kprimaryColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ];
}