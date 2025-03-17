import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page

class ProfileCompletionPage extends StatefulWidget {
  final String uid;
  ProfileCompletionPage({required this.uid});

  @override
  _ProfileCompletionPageState createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedSex;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  Future<void> saveUserProfile() async {
    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching email. Try again!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
      'first_name': firstNameController.text.trim(),
      'middle_initial': middleInitialController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'age': int.tryParse(ageController.text.trim()) ?? 0,
      'sex': selectedSex,
      'address': addressController.text.trim(),
      'email': userEmail, // ✅ Save email in Firestore
    });

    if (!mounted) return;

    // ✅ Show success alert and redirect to login page
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Profile completed successfully! Please log in."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to login page
                  (route) => false, // Remove all previous routes
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: middleInitialController, decoration: InputDecoration(labelText: "Middle Initial")),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Last Name")),
            TextField(controller: ageController, decoration: InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: selectedSex,
              onChanged: (value) => setState(() => selectedSex = value),
              items: ["Male", "Female"].map((sex) => DropdownMenuItem(value: sex, child: Text(sex))).toList(),
              decoration: InputDecoration(labelText: "Sex"),
            ),
            TextField(controller: addressController, decoration: InputDecoration(labelText: "Address")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveUserProfile, child: const Text("Save Profile")),
          ],
        ),
      ),
    );
  }
}
