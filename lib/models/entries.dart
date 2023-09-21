import 'dart:io';

class Entry {
  String flatId;
  final String flatNo;
  final String dname;
  final bool status;
  final String wing;

  Entry({
    required this.flatId,
    required this.flatNo,
    required this.dname,
    required this.status,
    required this.wing,
  });
}
