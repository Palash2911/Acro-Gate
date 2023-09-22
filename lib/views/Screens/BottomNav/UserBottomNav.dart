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
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [HomePage(), const History(), const Profile()];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
        icon: Icon(FeatherIcons.home),
        title: ("Home"),
        activeColorPrimary: kprimaryColor,
        inactiveColorPrimary: kprimaryColor),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.doorbell_outlined),
      title: ("Notifications"),
      activeColorPrimary: kprimaryColor,
    ),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.person_4_outlined),
        title: ("Profile"),
        activeColorPrimary: kprimaryColor,
        inactiveColorPrimary: kprimaryColor),
  ];
}

// class UserBottomBar extends StatefulWidget {
//   const UserBottomBar({super.key});

//   @override
//   State<UserBottomBar> createState() => _UserBottomBarState();
// }

// class _UserBottomBarState extends State<UserBottomBar> {
//   final PersistentTabController _controller =
//       PersistentTabController(initialIndex: 0);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PersistentTabView(
//         context,
//         controller: _controller,
//         screens: _buildScreens(),
//         items: _navBarsItems(),
//         navBarStyle: NavBarStyle.style10,
//         backgroundColor: kprimaryColor,
//       ),
//     );
//   }
// }

// List<Widget> _buildScreens() {
//   return [HomeScreen(), ChatScreen(), ActivityScreen()];
// }

// List<PersistentBottomNavBarItem> _navBarsItems() {
//   return [
//     PersistentBottomNavBarItem(
//       icon: Icon(
//         FeatherIcons.home,
//       ),
//       title: ("Home"),
//       textStyle: kTextPopR12,
//       activeColorPrimary: ksecondaryColor,
//     ),
//     PersistentBottomNavBarItem(
//       icon: Icon(FeatherIcons.messageSquare),
//       title: ("Chat"),
//       activeColorPrimary: ksecondaryColor,
//     ),
//     PersistentBottomNavBarItem(
//         icon: Icon(FeatherIcons.activity),
//         title: ("Activity"),
//         activeColorPrimary: ksecondaryColor,
//         inactiveColorPrimary: ksecondaryColor),
//   ];
// }
