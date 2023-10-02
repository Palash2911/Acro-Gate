import 'dart:io';

class Users {
  final String id;
  final String flatNo;
  final String name;
  final String phone;
  final String wing;
  final File? localUrl;
  String firebaseUrl;
  final List<String> maidNames;
  final List<String> maidNumbers;

  Users({
    required this.id,
    required this.flatNo,
    required this.name,
    required this.phone,
    required this.wing,
    required this.localUrl,
    required this.firebaseUrl,
    required this.maidNames,
    required this.maidNumbers,
  });
}
