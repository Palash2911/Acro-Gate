import 'package:acrogate/views/Screens/BottomNav/Editprofile.dart';
import 'package:acrogate/views/Screens/Onboarding/Login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../constants.dart';
import '../Cards/ProfileCard.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var dataLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 550), () {
      setState(() {
        dataLoaded = true;
      });
    });
  }

  void signOut(BuildContext ctx) async {
    await Provider.of<Auth>(ctx, listen: false).signOut().catchError((e) {
      print(e);
    }).then((value) {
      Fluttertoast.showToast(
        msg: "Signed Out Successfully",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(ctx, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
      );
    });
  }

  Future<void> editProfile() async {
    var authToken = Provider.of<Auth>(context, listen: false).token;
    await Provider.of<UserProvider>(context, listen: false)
        .getUserDetails(authToken)
        .then((value) {
      Navigator.of(context, rootNavigator: true)
          .pushNamed(EditProfile.routeName, arguments: [
        value!.id,
        value.name,
        value.flatNo,
        value.wing,
        value.phone,
        value.firebaseUrl,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return !dataLoaded
        ? Scaffold(
            backgroundColor: ksecondaryColor,
            body: Center(
              child: SizedBox(
                height: 350.0,
                child: Image.asset(
                  'assets/animation/loading.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 0.0),
                child: Text(
                  'Profile',
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    ProfileCard(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        children: [
                          Card(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side:
                                  BorderSide(color: kprimaryColor, width: 2.0),
                            ),
                            elevation: 0.0,
                            child: ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: kprimaryColor,
                              ),
                              title: Text(
                                'Profile',
                                style: kTextPopM16,
                              ),
                              subtitle: const Text('Edit Profile'),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                              onTap: editProfile,
                            ),
                          ),
                          //Sign Out
                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side:
                                  BorderSide(color: kprimaryColor, width: 2.0),
                            ),
                            elevation: 0.0,
                            child: ListTile(
                              leading: Icon(
                                Icons.logout_rounded,
                                size: 50.0,
                                color: kprimaryColor,
                              ),
                              title: Text(
                                'Sign Out',
                                style: kTextPopM16,
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                              onTap: () => signOut(context),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
