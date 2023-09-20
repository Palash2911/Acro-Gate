import 'package:acrogate/providers/auth_provider.dart';
import 'package:acrogate/views/Screens/Onboarding/Login.dart';
import 'package:acrogate/views/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UserAppdrawer extends StatefulWidget {
  const UserAppdrawer({super.key});

  @override
  State<UserAppdrawer> createState() => _UserAppdrawerState();
}

class _UserAppdrawerState extends State<UserAppdrawer> {
  var pp = "";
  var name = "";
  var authToken = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setProfilePic();
  }

  void setProfilePic() async {
    var authProvider = Provider.of<Auth>(context, listen: false);
    pp = authProvider.profilePic;
    name = authProvider.uName;
    authToken = authProvider.token;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xfff1BB273),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: pp.isNotEmpty
                      ? Image.network(pp).image
                      : const AssetImage('assets/images/user.png'),
                ),
                Text(
                  name,
                  style: kTextPopM16.copyWith(color: ksecondaryColor),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => UserProfile(
              //       isUser: true,
              //       authToken: authToken,
              //     ),
              //   ),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              Fluttertoast.showToast(
                msg: " Thank You For Choosing Aikyam",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                backgroundColor: kprimaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Provider.of<Auth>(context, listen: false).signOut().then((value) {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(builder: (context) => LogIn()));
              });
            },
          ),
        ],
      ),
    );
  }
}
