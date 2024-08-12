import 'dart:convert';
import 'dart:io';
import 'package:acrogate/models/entries.dart';
import 'package:acrogate/providers/entry_provider.dart';
import 'package:acrogate/providers/firebasenotification.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  final _phoneController = TextEditingController();
  ModalState _modalState = ModalState.Initial;

  String get phone => _phoneController.text;
  String get name => _nameController.text;
  final _form = GlobalKey<FormState>();
  List<Wing> wings = [];
  var firebaseNoti = FirebaseNotification();

  File? _image;
  var isLoading = false;

  Future<void> _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  List<String> flats = [
    "Select Flat No",
    "101",
    "102",
    "201",
    "202",
    "301",
    "302",
    "401",
    "402",
    "501",
    "502",
    "601",
    "602",
    "701",
    "702",
    "801",
    "802",
    "901",
    "902",
    "1001",
    "1002",
    "1101",
    "1102",
    "1201",
    "1202",
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = "";
    _phoneController.text = "";
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future notificationSettings() async {
    firebaseNoti.onTokenRefresh();
  }

  void _closeEntry(BuildContext context) {
    getStatus('');
    setState(() {
      isLoading = false;
    });
  }

  Future _createEntry(BuildContext ctx) async {
    var entryProvider = Provider.of<EntryProvider>(ctx, listen: false);
    final isValid = _form.currentState!.validate();
    setState(() {
      isLoading = true;
      _modalState = ModalState.Loading;
    });
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
          phone: phone,
          firebaseUrl: '',
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
          time: DateFormat('HH:mm:ss').format(DateTime.now()).toString(),
        ),
        _image!,
      )
          .catchError((e) {
        setState(() {
          isLoading = false;
        });
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
          entryProvider
              .getToken(selectedFlat, wing)
              .then((List<String> fcmt) async {
            if (fcmt.isNotEmpty) {
              for (int i = 0; i < fcmt.length; i++) {
                var data = {
                  'to': fcmt[i],
                  'notification': {
                    'title': 'Some One At Door 🚪',
                    'body': 'Please Approve Entry !!',
                  }
                };
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
                    print(response.body);
                  } else {
                    print(response.body);
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  print("Error sending notification: $e");
                }
              }
            }
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
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
          getStatus(res.toString());
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
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  void getStatus(String eid) {
    if (eid == "") {
      reset("Entry Denied");
    } else {
      Future.delayed(const Duration(seconds: 4), () async {
        var entryProvider = Provider.of<EntryProvider>(context, listen: false);
        entryProvider
            .getNotification(selectedFlat, wing, eid)
            .then((String value) {
          if (value.isEmpty || value == "Pending") {
            getStatus(eid);
          } else {
            reset(value);
          }
        });
      });
    }
  }

  void reset(String val) {
    if (val == "Entry Approved") {
      _modalState = ModalState.Success;
    } else {
      _modalState = ModalState.Deny;
    }
    setState(() {
      isLoading = false;
      _nameController.text = "";
      _phoneController.text = "";
      _image = null;
      selectedFlat = flats[0];
      wings.forEach((wing) => wing.isSelected = false);
      wing = "";
    });
    _showApprovalModal(context, _modalState);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 100),
              SizedBox(
                height: 40, //height of button
                width: 200, //width of button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, //background color of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10)),
                    //content padding inside button
                  ),
                  onPressed: () {
                    _closeEntry(context);
                  },
                  child: const Text(
                    "Cancel Request",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              )
            ],
          )
        : Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 15.0),
            padding: const EdgeInsets.all(9.0),
            decoration: BoxDecoration(
              border: Border.all(color: kprimaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: MediaQuery.of(context).size.height - 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
                          InkWell(
                            onTap: () {
                              _getImageFromCamera();
                            },
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  _image != null ? FileImage(_image!) : null,
                              child: _image == null
                                  ? const Icon(Icons.camera_alt, size: 40.0)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12.0),
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
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: kTextPopR14,
                              counterText: '',
                              icon: const Icon(Icons.phone),
                              filled: true,
                              fillColor: Colors.green.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Phone No.!';
                              } else if (value.length != 10) {
                                return 'Phone Number must be 10 digits long.';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                          ),
                          const SizedBox(height: 12.0),
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
                                  border: Border.all(
                                      color: kprimaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
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
                                                  wings[index].isSelected =
                                                      true;
                                                  wing = wings[index].wing;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 6),
                                                child: Chip(
                                                  label: Text(
                                                    wings[index].wing,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: !wings[index]
                                                                .isSelected
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
                          const SizedBox(height: 12.0),
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
                                  border: Border.all(
                                      color: kprimaryColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: DropdownButton<String>(
                                  value: selectedFlat.isNotEmpty
                                      ? selectedFlat
                                      : "",
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
                                  style:
                                      kTextPopR14.copyWith(color: Colors.black),
                                  icon: const Icon(IconData(0)),
                                  isExpanded: true,
                                  underline: Container(),
                                  elevation: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            height: 40, //height of button
                            width: 220, //width of button
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    kprimaryColor, //background color of button
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(10)),
                                //content padding inside button
                              ),
                              onPressed: () {
                                _createEntry(context);
                              },
                              child: Text(
                                "Send Request",
                                style:
                                    kTextPopB14.copyWith(color: Colors.white),
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

  void _showApprovalModal(BuildContext context, ModalState modalState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (modalState == ModalState.Loading)
                Center(
                  child: SizedBox(
                    height: 300.0,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/animation/loading2.gif',
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: 35, //height of button
                          width: 120, //width of button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, //background color of button
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _modalState = ModalState.Initial;
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ), // Show loading GIF
              if (modalState == ModalState.Success)
                Center(
                  child: SizedBox(
                    height: 300.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/animation/approve.gif',
                          fit: BoxFit.contain,
                        ),
                        const Text(
                          "IN",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                          height: 35, //height of button
                          width: 120, //width of button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  kprimaryColor, //background color of button
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _modalState = ModalState.Initial;
                            },
                            child: Text(
                              "OK",
                              style: kTextPopB16.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (modalState == ModalState.Deny)
                Center(
                  child: SizedBox(
                    height: 250.0,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/animation/deny.gif',
                          fit: BoxFit.contain,
                        ),
                        const Text(
                          "OUT",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
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
                                  Colors.red, //background color of button
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _modalState = ModalState.Initial;
                            },
                            child: Text(
                              "OK",
                              style: kTextPopB16.copyWith(color: Colors.white),
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
  }
}

enum ModalState {
  Initial,
  Loading,
  Success,
  Deny,
}

class Wing {
  String wing;
  IconData icon;
  bool isSelected;

  Wing(this.wing, this.icon, this.isSelected);
}
