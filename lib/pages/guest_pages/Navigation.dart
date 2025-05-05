//guest navigation page
import 'package:docpechayapp/pages/guest_pages/AboutUs.dart';
import 'package:docpechayapp/pages/guest_pages/FAQ.dart';
import 'package:docpechayapp/pages/guest_pages/SettingsPage.dart';
import 'package:docpechayapp/pages/guest_pages/calculation/Calculate.dart';
import 'package:docpechayapp/pages/guest_pages/databank.dart';
import 'package:docpechayapp/pages/guest_pages/homescreen.dart';
import 'package:docpechayapp/pages/guest_pages/scanning/camerascanner.dart';
import 'package:docpechayapp/pages/guest_pages/treatmentbank.dart';
import 'package:docpechayapp/pages/user_profile/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Navigation_guest extends StatefulWidget {
  const Navigation_guest({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Navigation_guest> {
  int _page = 0;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

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
            /*ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Info'),
              onTap: () {
                setState(() {
                  _page = 8;
                });
                Navigator.pop(context);
              },
            ),*/
            ListTile(
              leading: const Icon(Icons.local_florist),
              title: const Text('Fertilizer & Pesticides Info'),
              onTap: () {
                setState(() {
                  _page = 7;
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
            const Divider(), // Add a divider before logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Guest Sign out', style: TextStyle(color: Colors.red)),
              onTap: () {
                _logout();
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
        return const HomeWidget_guest();
      case 1:
        return ScannerPage();
      case 2:
        return const Calculate_guest();
      case 3:
        return const AboutUs_guest();
      case 4:
        return const FAQ_guest();
      case 5:
        return const SettingsPage_guest();
      case 6:
        return const glossary_index_guest();
      case 7:
        return const Treatmentbank_guest();
      /*case 8:
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (!mounted) return Container();

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
        return MonitoringNav();*/
      default:
        return Container();
    }
  }
}
