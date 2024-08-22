import 'package:flutter/material.dart';
import 'package:sensor2/login_page.dart';
import 'package:get/get.dart';
import 'database_helper.dart'; // Import the DatabaseHelper

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  // Initialize DatabaseHelper
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
