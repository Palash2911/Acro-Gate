import 'package:flutter/material.dart';

import '../../constants.dart';

class AdminListCard extends StatelessWidget {
  final String dname;
  final String flatNo;
  final String wing;
  final String approve;

  AdminListCard({
    required this.dname,
    required this.flatNo,
    required this.wing,
    required this.approve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: kprimaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dname,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  approve,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Flat No: $flatNo',
                  style: const TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Wing: $wing-Wing',
                  style: const TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
