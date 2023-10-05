import 'package:acrogate/views/Screens/AdminBottomNav/AdminSide.dart';
import 'package:acrogate/views/Screens/AdminBottomNav/MaidScreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../constants.dart';

class AdminBottomBar extends StatefulWidget {
  static var routeName = '/admin-bottom-nav';

  const AdminBottomBar({super.key});

  @override
  State<AdminBottomBar> createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        hideNavigationBarWhenKeyboardShows: true,
        resizeToAvoidBottomInset: true,
        screens: _buildScreens(),
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [const AdminSide(), const MaidScreen()];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.doorbell_outlined),
      title: ("Entries"),
      activeColorPrimary: kprimaryColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.cleaning_services),
      title: ("Maid Entries"),
      activeColorPrimary: kprimaryColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ];
}