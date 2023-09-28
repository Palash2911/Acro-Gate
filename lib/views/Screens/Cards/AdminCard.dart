import 'dart:convert';

import 'package:acrogate/models/entries.dart';
import 'package:acrogate/providers/entry_provider.dart';
import 'package:acrogate/providers/firebasenotification.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

class AdminCard extends StatefulWidget {
  const AdminCard({Key? key}) : super(key: key);

  @override
  State<AdminCard> createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  String wing = "";
  late String selectedFlat;
  final _nameController = TextEditingController();
  String get name => _nameController.text;
  final _form = GlobalKey<FormState>();
  List<Wing> wings = [];
  var firebaseNoti = FirebaseNotification();

  List<String> flats = [
    "Select Flat No",
    "1001",
    "1002",
    "1003",
    "1004",
    "2001",
    "2002",
    "2003",
    "2004",
    "3001",
    "3002",
    "3003",
    "3004",
    "4001",
    "4002",
    "4003",
    "4004",
    "5001",
    "5002",
    "5003",
    "5004",
    "6001",
    "6002",
    "6003",
    "6004",
    "7001",
    "7002",
    "7003",
    "7004",
    "8001",
    "8002",
    "8003",
    "8004",
    "9001",
    "9002",
    "9003",
    "9004",
    "1101",
    "1102",
    "1103",
    "1104",
    "1201",
    "1202",
    "1203",
    "1204"
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = "";
    selectedFlat = flats[0];
    wings.add(Wing("A", Icons.battery_0_bar, false));
    wings.add(Wing("B", Icons.battery_3_bar, false));
    wings.add(Wing("C", Icons.battery_full, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notificationSettings();
  }

  Future notificationSettings() async {
    firebaseNoti.onTokenRefresh();
  }

  Future _createEntry(BuildContext ctx) async {
    var entryProvider = Provider.of<EntryProvider>(ctx, listen: false);
    final isValid = _form.currentState!.validate();
    // setState(() {
    //   isLoading = true;
    // });
    _form.currentState!.save();
    if (isValid) {
      await entryProvider
          .newEntry(
        Entry(
          flatId: "",
          dname: name,
          status: "Pending",
          flatNo: selectedFlat,
          wing: wing,
          phone: '',
          firebaseUrl: '',
        ),
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
      }).then((res) async {
        if (res) {
          entryProvider.getToken(selectedFlat, wing).then((String fcmt) async {
            print('FCMToken: $fcmt');
            if (fcmt.isNotEmpty) {
              var data = {
                'to': fcmt,
                'notification': {
                  'title': 'Some One At Door 🚪',
                  'body': 'Please Approve Entry !!',
                }
              };
              print(data);
              try {
                final response = await http.post(
                  Uri.parse("https://fcm.googleapis.com/fcm/send"),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':
                        'key=AAAAOSftUfs:APA91bGK8JoiHH2WsJHz4HZA8PgWq_Ai7TcKCmhq-mbDTzV0wkUrVCFSewOnxlQ4H5uYzdl6PuNoMVhaZhTLzu3uzSZ6WYS_UhfwEEIEQFwhUp6JZWUDGzmKCKEUQUUhYq5F98k8Up_I', // Replace with your server key
                  },
                );

                if (response.statusCode == 200) {
                  print("Notification sent successfully");
                  print(response.body);
                } else {
                  print(
                      "Failed to send notification. Status code: ${response.statusCode}");
                  print(response.body);
                }
              } catch (e) {
                print("Error sending notification: $e");
              }
            }
          }).catchError((e) {
            print(e);
          });
          Fluttertoast.showToast(
            msg: "Request Sent Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: kprimaryColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          _nameController.text = "";
          selectedFlat = flats[0];
          setState(() {
            wings.forEach((wing) => wing.isSelected = false);
            wing = ""; // Optionally clear the selected wing
          });
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
    } else {
      // setState(() {
      //   isLoading = false;
      // });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 15.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: kprimaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Enter Entry Details",
                      style: kTextPopB16,
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: kTextPopR14,
                        icon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.green.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Name!';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_city,
                          size: 32.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            border: Border.all(color: kprimaryColor, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: wings.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            wings.forEach((wing) =>
                                                wing.isSelected = false);
                                            wings[index].isSelected = true;
                                            wing = wings[index].wing;
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 6),
                                          child: Chip(
                                            label: Text(
                                              wings[index].wing,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      !wings[index].isSelected
                                                          ? Colors.green
                                                          : Colors.white),
                                            ),
                                            backgroundColor:
                                                !wings[index].isSelected
                                                    ? Colors.white
                                                    : Colors.green,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.room,
                          size: 32.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12.0),
                        Container(
                          padding: const EdgeInsets.only(left: 9.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: kprimaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: MediaQuery.of(context).size.width * 0.44,
                          child: DropdownButton<String>(
                            value: selectedFlat.isNotEmpty ? selectedFlat : "",
                            hint: Text("Select Flat", style: kTextPopR14),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFlat = newValue ?? "";
                              });
                            },
                            items: flats.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item, style: kTextPopR14),
                              );
                            }).toList(),
                            style: kTextPopR14.copyWith(color: Colors.black),
                            icon: const Icon(IconData(0)),
                            isExpanded: true,
                            underline: Container(),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 40, //height of button
                      width: 200, //width of button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kprimaryColor, //background color of button
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(10)),
                          //content padding inside button
                        ),
                        onPressed: () => _createEntry(context),
                        child: const Text(
                          "Send Approval Request",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Wing {
  String wing;
  IconData icon;
  bool isSelected;

  Wing(this.wing, this.icon, this.isSelected);
}
