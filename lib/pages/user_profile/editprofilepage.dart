import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String uid;
  const EditProfilePage({required this.uid, Key? key}) : super(key: key);

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
      const SnackBar(content: Text("Profile updated successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                        ? NetworkImage(_profileImageUrl!)
                        : null) as ImageProvider<Object>?,
                child: _image == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty)
                    ? const Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    _buildTextField(firstNameController, "First Name"),
                    _buildTextField(middleInitialController, "Middle Initial"),
                    _buildTextField(lastNameController, "Last Name"),
                    _buildTextField(ageController, "Age", keyboardType: TextInputType.number),
                    _buildDropdownField(),
                    _buildTextField(addressController, "Address"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: updateUserProfile,
                icon: const Icon(Icons.save),
                label: const Text("Save Changes", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedSex,
        onChanged: (value) => setState(() => selectedSex = value),
        items: ["Male", "Female"]
            .map((sex) => DropdownMenuItem(value: sex, child: Text(sex)))
            .toList(),
        decoration: InputDecoration(
          labelText: "Sex",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
