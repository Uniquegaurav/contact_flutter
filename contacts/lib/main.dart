import 'package:contacts/util/constants.dart';
import 'package:contacts/model/contact.dart';
import 'package:contacts/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());
  await Hive.openBox(Constant.BOX_NAME);
  runApp(const MaterialApp(
    home: Home(),
  ));
}
