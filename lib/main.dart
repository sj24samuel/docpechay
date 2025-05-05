import 'package:docpechayapp/pages/user_profile/login_page.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:docpechayapp/pages/user_pages/calculation/Calculate.dart';
import 'package:docpechayapp/pages/user_pages/scanning/camerascanner.dart';
import 'package:docpechayapp/pages/guest_pages/scanning/camerascanner.dart';
import 'package:docpechayapp/pages/guest_pages/calculation/Calculate.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    //webProvider: ReCaptchaEnterpriseProvider("your-site-key"), // For Web
    androidProvider: AndroidProvider.playIntegrity, // For Android
    //appleProvider: AppleProvider.deviceCheck, // For iOS
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pechay Doctor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 150, 235, 14)),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  } 
}