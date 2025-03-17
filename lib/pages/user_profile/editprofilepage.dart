import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String uid;
  EditProfilePage({required this.uid});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedSex;
  File? _image;
  String? _profileImageUrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        firstNameController.text = userData['first_name'] ?? '';
        middleInitialController.text = userData['middle_initial'] ?? '';
        lastNameController.text = userData['last_name'] ?? '';
        ageController.text = userData['age'].toString();
        selectedSex = userData['sex'];
        addressController.text = userData['address'] ?? '';
        _profileImageUrl = userData['profile_picture'];
      });
    }
  }

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

  Future<void> updateUserProfile() async {
    String? imageUrl = _profileImageUrl;

    if (_image != null) {
      imageUrl = await uploadImage(_image!);
    }

    await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
      'first_name': firstNameController.text.trim(),
      'middle_initial': middleInitialController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'age': int.tryParse(ageController.text.trim()) ?? 0,
      'sex': selectedSex,
      'address': addressController.text.trim(),
      'profile_picture': imageUrl ?? "",
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                        ? NetworkImage(_profileImageUrl!)
                        : null) as ImageProvider<Object>?,
                child: _image == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty)
                    ? Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateUserProfile, child: Text("Save Changes")),
          ],
        ),
      ),
    );
  }
}
