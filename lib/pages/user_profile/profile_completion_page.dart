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
  bool isLoading = false;

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() => _image = File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() => _image = File(pickedFile.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
    // ✅ Validation
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        selectedSex == null ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    int? age = int.tryParse(ageController.text.trim());
    if (age == null || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid age.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
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
        'age': age,
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? const Icon(Icons.person, size: 60, color: Colors.white70)
                              : null,
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF4CAF50),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Form container
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildTextField("First Name", firstNameController),
                          const SizedBox(height: 12),
                          _buildTextField("Middle Initial", middleInitialController),
                          const SizedBox(height: 12),
                          _buildTextField("Last Name", lastNameController),
                          const SizedBox(height: 12),
                          _buildTextField("Age", ageController, keyboardType: TextInputType.number),
                          const SizedBox(height: 12),
                          _buildDropdownField(),
                          const SizedBox(height: 12),
                          _buildTextField("Address", addressController),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save Profile", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Indicator
          if (isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: selectedSex,
      decoration: InputDecoration(
        labelText: "Sex",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
      ),
      items: ["Male", "Female"]
          .map((sex) => DropdownMenuItem(value: sex, child: Text(sex)))
          .toList(),
      onChanged: (value) => setState(() => selectedSex = value),
    );
  }
}
