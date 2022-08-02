// import 'package:contacts/controllers/contact_controller.dart';
import 'package:contacts/screens/home/home_screen_widget.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: HomeScreenWidget(),
    );
  }
}
