import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/users.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../constants.dart';
import '../UserBottomNav/UserBottomNav.dart';

class Register extends StatefulWidget {
  static var routeName = "/register";
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _flatController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String get name => _nameController.text;
  String get phone => _phoneController.text;
  String get flat => _flatController.text;
  List<TextEditingController> _maidNameControllers = [];
  List<TextEditingController> _maidNumberControllers = [];
  String wing = "";
  String maidEntry = "";
  String privacy = "";
  late String selectedFlat;

  File? imageFile;
  var isLoading = false;
  final _form = GlobalKey<FormState>();

  List<Wing> wings = [];
  List<Maids> maidApprove = [];
  List<MaidEntry> maidEntries = [];
  List<Maids> privacies = [];

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
    _flatController.text = "";
    selectedFlat = flats[0];
    maidApprove.add(Maids("Yes", false));
    maidApprove.add(Maids("No", true));
    privacies.add(Maids("Yes", false));
    privacies.add(Maids("No", false));
    wings.add(Wing("A", Icons.battery_0_bar, false));
    wings.add(Wing("B", Icons.battery_3_bar, false));
    wings.add(Wing("C", Icons.battery_full, false));
    maidEntries.add(MaidEntry('', ''));
    for (int i = 0; i < maidEntries.length; i++) {
      _maidNameControllers.add(TextEditingController());
      _maidNumberControllers.add(TextEditingController());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      _phoneController.text = auth.phoneNumber.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _flatController.dispose();
    for (var controller in _maidNameControllers) {
      controller.dispose();
    }
    for (var controller in _maidNumberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future _createProfile(BuildContext ctx) async {
    var authProvider = Provider.of<Auth>(ctx, listen: false);
    var userProvider = Provider.of<UserProvider>(ctx, listen: false);
    final isValid = _form.currentState!.validate();
    setState(() {
      isLoading = true;
    });
    _form.currentState!.save();
    if (isValid) {
      List<String> maidNamesList = [];
      List<String> maidNumList = [];
      for (TextEditingController controller in _maidNameControllers) {
        maidNamesList.add(controller.text);
      }
      for (TextEditingController controller in _maidNumberControllers) {
        maidNumList.add(controller.text);
      }
      await userProvider
          .registerUser(
        Users(
          id: authProvider.token,
          name: name,
          phone: phone,
          flatNo: selectedFlat,
          wing: wing,
          localUrl: imageFile,
          firebaseUrl: "",
          maidNames: maidEntry == "No" ? [] : maidNamesList,
          maidNumbers: maidEntry == "No" ? [] : maidNumList,
          privacy: privacy,
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
      }).then((_) async {
        await Provider.of<Auth>(context, listen: false)
            .autoLogin()
            .then((value) {
          Fluttertoast.showToast(
            msg: "Successfully Registered !",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: kprimaryColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          setState(() {
            isLoading = false;
          });
          const initin = 0;
          Navigator.of(ctx)
              .pushReplacementNamed(UserBottomBar.routeName, arguments: initin);
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  Future _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset(
                    'assets/animation/loading.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 0.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30.0),
                      //profile picture
                      Stack(
                        children: [
                          imageFile != null
                              ? CircleAvatar(
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundImage: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    ).image,
                                    radius: 60,
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/logo.png'),
                                    radius: 60,
                                  ),
                                ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: InkWell(
                              onTap: () {
                                _getFromGallery();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: imageFile != null
                                      ? const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      //bio textfield
                      Form(
                        key: _form,
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
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
                                  return 'Please enter name!';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 15.0),
                            //contact
                            TextFormField(
                              maxLength: 10,
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: "Contact number",
                                hintStyle: kTextPopR14,
                                icon: const Icon(Icons.phone),
                                filled: true,
                                fillColor: Colors.green.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                final phoneRegex = RegExp(r'^\+?\d{9,15}$');
                                if (!phoneRegex.hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.lock,
                                  size: 32.0,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12.0),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    border: Border.all(
                                        color: kprimaryColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10.0),
                                      AutoSizeText(
                                        'Number Privacy',
                                        style: kTextPopR12.copyWith(
                                            color: Colors.black54),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 9.0),
                                      SizedBox(
                                        height: 50,
                                        width: 120,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: privacies.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    privacies.forEach(
                                                        (private) =>
                                                            private.isSelected =
                                                                false);
                                                    privacies[index]
                                                        .isSelected = true;
                                                    privacy = privacies[index]
                                                        .approve;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 9),
                                                  child: Chip(
                                                    label: Text(
                                                      privacies[index].approve,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: !privacies[
                                                                      index]
                                                                  .isSelected
                                                              ? Colors.green
                                                              : Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        !privacies[index]
                                                                .isSelected
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
                            //  WING
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
                                        color: kprimaryColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10.0),
                                      Text(
                                        'WING',
                                        style: kTextPopR14.copyWith(
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(width: 9.0),
                                      SizedBox(
                                        height: 50,
                                        width: 200,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: wings.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    wings.forEach((wing) => wing
                                                        .isSelected = false);
                                                    wings[index].isSelected =
                                                        true;
                                                    wing = wings[index].wing;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 9),
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
                                    border: Border.all(
                                        color: kprimaryColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  child: DropdownButton<String>(
                                    value: selectedFlat.isNotEmpty
                                        ? selectedFlat
                                        : "",
                                    hint:
                                        Text("Select Flat", style: kTextPopR14),
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
                                    style: kTextPopR14.copyWith(
                                        color: Colors.black),
                                    icon: const Icon(IconData(0)),
                                    isExpanded: true,
                                    underline: Container(),
                                    elevation: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_4,
                                  size: 32.0,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12.0),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    border: Border.all(
                                        color: kprimaryColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10.0),
                                      Text(
                                        'Maid Approval',
                                        style: kTextPopR14.copyWith(
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(width: 9.0),
                                      SizedBox(
                                        height: 50,
                                        width: 120,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: maidApprove.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    maidApprove.forEach(
                                                        (maid) =>
                                                            maid.isSelected =
                                                                false);
                                                    maidApprove[index]
                                                        .isSelected = true;
                                                    maidEntry =
                                                        maidApprove[index]
                                                            .approve;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 9),
                                                  child: Chip(
                                                    label: Text(
                                                      maidApprove[index]
                                                          .approve,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: !maidApprove[
                                                                      index]
                                                                  .isSelected
                                                              ? Colors.green
                                                              : Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        !maidApprove[index]
                                                                .isSelected
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
                            maidEntry == "Yes"
                                ? Column(
                                    children: List.generate(
                                      maidEntries.length,
                                      (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                controller:
                                                    _maidNameControllers[index],
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  hintText: "Maid Name",
                                                  hintStyle: kTextPopR14,
                                                  filled: true,
                                                  fillColor:
                                                      Colors.green.shade100,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter maid name!';
                                                  }
                                                  return null;
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Flexible(
                                              child: TextFormField(
                                                maxLength: 10,
                                                controller:
                                                    _maidNumberControllers[
                                                        index],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  hintText: "Maid Number",
                                                  hintStyle: kTextPopR14,
                                                  filled: true,
                                                  fillColor:
                                                      Colors.green.shade100,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter maid phone number';
                                                  }
                                                  final phoneRegex =
                                                      RegExp(r'^\+?\d{9,15}$');
                                                  if (!phoneRegex
                                                      .hasMatch(value)) {
                                                    return 'Please enter a valid phone number';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 1,
                                  ),
                            const SizedBox(height: 15.0),
                            maidEntry == "Yes"
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      maidEntries.length > 0
                                          ? ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  maidEntries.removeLast();
                                                  _maidNumberControllers
                                                      .removeLast();
                                                  _maidNameControllers
                                                      .removeLast();
                                                });
                                              },
                                              child: const Text("Remove Maid"),
                                            )
                                          : SizedBox(
                                              width: 1,
                                            ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            maidEntries.add(MaidEntry('', ''));
                                            _maidNameControllers
                                                .add(TextEditingController());
                                            _maidNumberControllers
                                                .add(TextEditingController());
                                          });
                                        },
                                        child: const Text("Add Maid"),
                                      ),
                                    ],
                                  )
                                : const SizedBox(height: 1.0),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              height: 64, //height of button
                              width: 250, //width of button
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        kprimaryColor, //background color of button
                                    shape: RoundedRectangleBorder(
                                        //to set border radius to button
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(
                                        18) //content padding inside button
                                    ),
                                onPressed: () => _createProfile(context),
                                child: AutoSizeText(
                                  "Register Flat",
                                  style:
                                      kTextPopB16.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
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

class Maids {
  String approve;
  bool isSelected;

  Maids(this.approve, this.isSelected);
}

class MaidEntry {
  String name;
  String number;

  MaidEntry(this.name, this.number);
}
