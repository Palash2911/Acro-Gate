import 'package:acrogate/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/entry_provider.dart';
import '../../constants.dart';

class NotificationCard extends StatefulWidget {
  final String DName;
  final String nid;
  final String status;
  final String url;
  final String phone;
  final String date;
  final String time;

  const NotificationCard({
    super.key,
    required this.DName,
    required this.nid,
    required this.status,
    required this.url,
    required this.phone,
    required this.date,
    required this.time,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  var isLoading = false;
  var accepted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    accepted = widget.status == "Pending" ? false : true;
  }

  Future applyReject(String ar) async {
    if (ar == "Accept") {
      await Provider.of<EntryProvider>(context, listen: false)
          .acceptRejectUser("Accept", widget.nid)
          .then((value) {
        Fluttertoast.showToast(
          msg: "Entry Accepted !",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          accepted = true;
          isLoading = false;
        });
      });
    } else {
      await Provider.of<EntryProvider>(context, listen: false)
          .acceptRejectUser("Reject", widget.nid)
          .then((value) {
        Fluttertoast.showToast(
          msg: "Entry Denied !",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          accepted = true;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 162,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.green, width: 2),
        ),
        color: ksecondaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: widget.url.isNotEmpty
                      ? Image.network(widget.url).image
                      : const AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  "Date: ${DateFormat('dd MMM, yyyy').format(DateFormat('yyyy-MM-dd').parse(widget.date))}",
                  style: kTextPopR12,
                ),
                Text(
                  "Time: ${DateFormat('h:mm a').format(DateTime.parse('1970-01-01 ${widget.time}'))}",
                  style: kTextPopR12,
                )
              ],
            ),
            SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text(
                    widget.DName,
                    style: kTextPopB14,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    "+91 ${widget.phone}",
                    style: kTextPopB14,
                  ),
                  accepted && widget.status != "Pending"
                      ? const SizedBox(
                          height: 7,
                        )
                      : const SizedBox(
                          height: 1,
                        ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : accepted && widget.status != "Pending"
                          ? Text(
                              widget.status,
                              style: TextStyle(
                                fontSize: 15,
                                color: widget.status == 'Entry Approved'
                                    ? Colors.green
                                    : Colors.red,
                                // You can adjust the colors based on your needs
                                fontWeight:
                                    FontWeight.bold, // Optional: Add fontWeight
                              ),
                            )
                          : Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 45,
                                  ),
                                  onPressed: () {
                                    applyReject("Accept");
                                    setState(() {
                                      isLoading = true;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 45,
                                  ),
                                  onPressed: () {
                                    applyReject("Reject");
                                    setState(() {
                                      isLoading = true;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
