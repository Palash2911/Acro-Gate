import 'package:flutter/material.dart';

import '../../constants.dart';

class HomePageCard extends StatelessWidget {
  final String name;
  final String flatNo;
  final String wing;
  final String imageUrl;

  HomePageCard({
    required this.name,
    required this.flatNo,
    required this.wing,
    required this.imageUrl,
  });

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
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            height: 40.0,
            width: 40.0,
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: imageUrl.isNotEmpty
                  ? Image.network(imageUrl).image
                  : const AssetImage('assets/images/calling.png'),
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
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
