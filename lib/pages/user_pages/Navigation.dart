import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docpechayapp/pages/user_pages/AboutUs.dart';
import 'package:docpechayapp/pages/user_pages/calculation/Calculate.dart';
import 'package:docpechayapp/pages/user_pages/FAQ.dart';
//import 'package:docpechayapp/pages/new_camerascanner.dart';
import 'package:docpechayapp/pages/user_profile/profile_completion_page.dart';
import 'package:docpechayapp/pages/user_pages/scanning/camerascanner.dart';
import 'package:docpechayapp/pages/user_pages/SettingsPage.dart';
import 'package:docpechayapp/pages/user_pages/homescreen.dart';
import 'package:docpechayapp/pages/user_pages/databank.dart';
import 'package:docpechayapp/pages/user_profile/userinfo.dart';
import 'package:docpechayapp/pages/user_pages/scanning/treatmentbank.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docpechayapp/pages/user_pages/monitoring/monitoring_page.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, Key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Navigation> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pechay Doctor",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 218, 18),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/plantbg.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Pechay Doctor',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _page = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_information),
              title: const Text('Pechay Doctor Scanner'),
              onTap: () {
                setState(() {
                  _page = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Treatment Calculation'),
              onTap: () {
                setState(() {
                  _page = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Disease Glossary'),
              onTap: () {
                setState(() {
                  _page = 6;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Info'),
              onTap: () {
                setState(() {
                  _page = 8;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Fertilizer & Pesticides Information'),
              onTap: () {
                setState(() {
                  _page = 7;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Monitoring'),
              onTap: () {
                setState(() {
                  _page = 9; // New index for the monitoring page
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('About Us'),
              onTap: () {
                setState(() {
                  _page = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('FAQ'),
              onTap: () {
                setState(() {
                  _page = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  _page = 5;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: getPage(_page),
    );
  }

  Widget getPage(int page) {
    switch (page) {
      case 0:
        return const HomeWidget();
      case 1:
        return const CameraScanner();
      case 2:
        return const Calculate();
      case 3:
        return const AboutUs();
      case 4:
        return const FAQ();
      case 5:
        return const SettingsPage();
      case 6:
        return const glossary_index();
      case 7:
        return const Treatmentbank();
      case 8:
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (!mounted) return Container(); // ✅ Prevent error if widget is unmounted

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.exists) {
              return UserInfoPage(uid: FirebaseAuth.instance.currentUser!.uid);
            } else {
              return ProfileCompletionPage(uid: FirebaseAuth.instance.currentUser!.uid);
            }
          },
        );
      case 9:
        return const MonitoringPage(); // ✅ Monitoring Page added
      default:
        return Container(); // Default page, you can replace it with another widget.
    }
  }
}