import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class HomePageCard extends StatelessWidget {
  final String name;
  final String flatNo;
  final String wing;
  final String imageUrl;
  final String number;

  HomePageCard({
    required this.name,
    required this.flatNo,
    required this.wing,
    required this.imageUrl,
    required this.number,
  });

  Future launchDialer() async {
    String url = 'tel:$number';
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: kprimaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: launchDialer,
            child: Container(
              margin: const EdgeInsets.only(right: 12.0),
              height: 40.0,
              width: 40.0,
              child: const CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/images/calling.png'),
              ),
            ),
          ),
          const SizedBox(width: 9,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flat No: $flatNo',
                      style: TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Wing: $wing-Wing',
                      style: TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
