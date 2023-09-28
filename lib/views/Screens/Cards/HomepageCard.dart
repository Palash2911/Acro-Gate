import 'package:auto_size_text/auto_size_text.dart';
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
      padding: const EdgeInsets.all(11.0),
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.67,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AutoSizeText(
                      name,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flat No: $flatNo',
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Wing: $wing-Wing',
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
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
