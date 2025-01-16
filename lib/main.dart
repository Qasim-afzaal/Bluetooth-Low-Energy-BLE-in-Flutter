import 'package:flutter/material.dart';
import 'package:flutter_ble/view/home_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(BLEApp());
}

class BLEApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BLE Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
