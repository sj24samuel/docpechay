import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class ProfileCompletionPage extends StatefulWidget {
  final String uid;
  const ProfileCompletionPage({required this.uid});

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
  File? _image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('profile_pics/${widget.uid}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  Future<void> saveUserProfile() async {
    String? imageUrl;
    if (_image != null) {
      imageUrl = await uploadImage(_image!);
    }

    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

    await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
      'first_name': firstNameController.text.trim(),
      'middle_initial': middleInitialController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'age': int.tryParse(ageController.text.trim()) ?? 0,
      'sex': selectedSex,
      'address': addressController.text.trim(),
      'email': docSnapshot['email'],
      'profile_picture': imageUrl ?? "",
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: firstNameController,
              decoration: buildInputDecoration("First Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: middleInitialController,
              decoration: buildInputDecoration("Middle Initial"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastNameController,
              decoration: buildInputDecoration("Last Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              decoration: buildInputDecoration("Age"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedSex,
              decoration: buildInputDecoration("Sex"),
              items: ["Male", "Female"]
                  .map((sex) => DropdownMenuItem(value: sex, child: Text(sex)))
                  .toList(),
              onChanged: (value) => setState(() => selectedSex = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: buildInputDecoration("Address"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Save Profile", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
