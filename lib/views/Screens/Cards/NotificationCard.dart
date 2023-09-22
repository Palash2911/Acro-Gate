import 'package:acrogate/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../providers/entry_provider.dart';
import '../../constants.dart';

class NotificationCard extends StatefulWidget {
  final String DName;
  final String nid;
  final String status;

  NotificationCard({
    super.key,
    required this.DName,
    required this.nid,
    required this.status,
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
    var authToken = Provider.of<Auth>(context, listen: false).token;
    if (ar == "Accept") {
      await Provider.of<EntryProvider>(context, listen: false)
          .acceptRejectUser("Accept", widget.nid, authToken)
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
          .acceptRejectUser("Reject", widget.nid, authToken)
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
    return SizedBox(
      height: 72,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.green, width: 2),
        ),
        color: ksecondaryColor,
        child: ListTile(
          title: Text(
            widget.DName,
            style: kTextPopB16,
          ),
          trailing: isLoading
              ? const CircularProgressIndicator()
              : accepted
                  ? Text(
                      widget.status,
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.status == 'Entry Approved'
                            ? Colors.green
                            : Colors.red,
                        // You can adjust the colors based on your needs
                        fontWeight: FontWeight.bold, // Optional: Add fontWeight
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(
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
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
