import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/entries.dart';
import '../../../providers/entry_provider.dart';
import '../../constants.dart';

class MaidCard extends StatelessWidget {
  final String name;
  final String flatNo;
  final String wing;
  final String number;

  MaidCard({
    required this.name,
    required this.flatNo,
    required this.wing,
    required this.number,
  });

  Future entryMaid(BuildContext ctx) async {
    var entryProvider = Provider.of<EntryProvider>(ctx, listen: false);
    await entryProvider
        .newEntry(
      Entry(
        flatId: "",
        dname: name,
        status: "Entry Approved",
        flatNo: flatNo,
        wing: wing,
        phone: number,
        firebaseUrl: '',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        time: DateFormat('HH:mm:ss').format(DateTime.now()).toString(),
      ),
      null,
    )
        .catchError((e) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).then((String res) async {
      if (res.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Entry Successfull!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Flat Not Found !!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
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
            onTap: () {
              entryMaid(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 250.0,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/animation/approve.gif',
                                  fit: BoxFit.contain,
                                ),
                                const Text(
                                  "IN",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                SizedBox(
                                  height: 35, //height of button
                                  width: 120, //width of button
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          kprimaryColor, //background color of button
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "OK",
                                      style: kTextPopB16.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12.0),
              height: 50.0,
              width: 50.0,
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: kprimaryColor,
                child: const Text(
                  "IN",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AutoSizeText(
                      name,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Wing: $wing-Wing',
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w500),
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
