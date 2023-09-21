import 'package:acrogate/providers/auth_provider.dart';
import 'package:acrogate/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class ProfileCard extends StatefulWidget {
  ProfileCard();

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String name = "Your Name";
  String uid = "";
  String flatNo = "";
  String wing = "";
  String url = "";

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    var authToken = Provider.of<Auth>(context, listen: false).token;
    await Provider.of<UserProvider>(context, listen: false)
        .getUserDetails(authToken)
        .then((value) {
      setState(() {
        name = value!.name;
        uid = value.id;
        flatNo = value.flatNo;
        wing = value.wing;
        url = value.firebaseUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 15.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(color: kprimaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    name,
                    style: GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Text(
                'Flat No: $flatNo',
                style: kTextPopB14,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Wing: $wing-Wing',
                style: kTextPopB14,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(11, 0, 0, 0),
            height: 100,
            width: 100,
            child: CircleAvatar(
              radius: 50.0,
              backgroundImage: url.isNotEmpty
                  ? Image.network(url).image
                  : const AssetImage('assets/images/male.png'),
            ),
          ),
        ],
      ),
    );
  }
}
