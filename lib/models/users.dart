import 'dart:io';

class Users {
  final String id;
  final String flatNo;
  final String name;
  final String email;
  final String phone;
  final String wing;
  final File? localUrl;
  String firebaseUrl;

  Users({
    required this.id,
    required this.flatNo,
    required this.name,
    required this.email,
    required this.phone,
    required this.wing,
    required this.localUrl,
    required this.firebaseUrl,
  });
}