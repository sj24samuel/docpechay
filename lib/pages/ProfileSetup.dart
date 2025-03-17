import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedSex;
  File? _imageFile;
  bool isUploading = false;

  /// Pick an image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("❌ Image picking error: $e");
    }
  }

  /// Upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";
      Reference ref = FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("✅ Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("❌ Image upload error: $e");
      return null;
    }
  }

  /// Save user info to Firestore
  Future<void> saveUserInfo() async {
    if (!_formKey.currentState!.validate() || selectedSex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields!")),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a profile picture!")),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    String? imageUrl = await _uploadImage(_imageFile!);
    if (imageUrl == null) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image upload failed!")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('user').doc('userinfo').set({
        'firstName': firstNameController.text,
        'middleInitial': middleInitialController.text,
        'lastName': lastNameController.text,
        'age': int.parse(ageController.text),
        'sex': selectedSex,
        'email': emailController.text,
        'address': addressController.text,
        'profilePicUrl': imageUrl,
      });

      print("✅ Data saved successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Created Successfully!")),
      );

      Navigator.pushReplacementNamed(context, '/userinfo');
    } catch (e) {
      print("❌ Firestore Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save profile!")),
      );
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Profile")),
      body: isUploading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.camera_alt, size: 50, color: Colors.black45)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      icon: const Icon(Icons.camera),
                      label: const Text("Capture Photo"),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(labelText: "First Name"),
                        validator: (value) => value!.isEmpty ? "Enter first name" : null),
                    TextFormField(controller: middleInitialController, decoration: const InputDecoration(labelText: "Middle Initial")),
                    TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(labelText: "Last Name"),
                        validator: (value) => value!.isEmpty ? "Enter last name" : null),
                    TextFormField(
                        controller: ageController,
                        decoration: const InputDecoration(labelText: "Age"),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? "Enter age" : null),
                    const SizedBox(height: 10),
                    const Text("Sex:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Radio(
                          value: "Male",
                          groupValue: selectedSex,
                          onChanged: (value) => setState(() => selectedSex = value),
                        ),
                        const Text("Male"),
                        const SizedBox(width: 20),
                        Radio(
                          value: "Female",
                          groupValue: selectedSex,
                          onChanged: (value) => setState(() => selectedSex = value),
                        ),
                        const Text("Female"),
                      ],
                    ),
                    TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (value) => value!.isEmpty ? "Enter email" : null),
                    TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: "Address"),
                        validator: (value) => value!.isEmpty ? "Enter address" : null),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: saveUserInfo, child: const Text("Save Profile")),
                  ],
                ),
              ),
            ),
    );
  }
}
