import 'package:acrogate/views/Screens/Onboarding/Login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
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
      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return !dataLoaded
        ? Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            child: SizedBox(
              height: 500.0,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 0.0),
                child: Text(
                  'Profile',
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 55,
                    ),
                    ProfileCard(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        children: [
                          //Profile option
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
                              onTap: () {
                                print("Clicked");
                              },
                            ),
                          ),
                          //Sign Out
                          SizedBox(
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
                          SizedBox(
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
                                'Switch to Admin',
                                style: kTextPopM16,
                              ),
                              subtitle: const Text('use admin app'),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                              onTap: () {
                                // TODO
                              },
                            ),
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
