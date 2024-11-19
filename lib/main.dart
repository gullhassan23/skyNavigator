import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skynavigator/Controllers/flight.dart';
import 'package:skynavigator/Screens/HOME.dart';

void main() async {
  await Get.put(FlightRoutesController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HOME(),
    );
  }
}
