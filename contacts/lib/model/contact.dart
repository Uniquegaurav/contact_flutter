import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String number;
  @HiveField(2)
  Uint8List? avatar;

  Contact({required this.name, required this.number, this.avatar});
}
