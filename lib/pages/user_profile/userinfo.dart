import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docpechayapp/pages/user_profile/editprofilepage.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  final String uid;
  const UserInfoPage({required this.uid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Information"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No user data found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final profilePic = userData['profile_picture'];
          final hasProfilePic = profilePic != null && profilePic is String && profilePic.isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: hasProfilePic
                        ? NetworkImage(profilePic)
                        // Uncomment the next line if you're using a local default image
                        // : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                        : null,
                    child: !hasProfilePic
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: Column(
                      children: [
                        ProfileDetailRow(label: "Name", value: "${userData['first_name']} ${userData['middle_initial'] ?? ''}. ${userData['last_name']}"),
                        ProfileDetailRow(label: "Age", value: "${userData['age']}"),
                        ProfileDetailRow(label: "Sex", value: "${userData['sex']}"),
                        ProfileDetailRow(label: "Address", value: "${userData['address']}"),
                        ProfileDetailRow(label: "Email", value: "${userData['email']}"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage(uid: uid)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const UpdatePasswordDialog(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.lock),
                  label: const Text("Update My Password", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailRow({required this.label, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatePasswordDialog extends StatefulWidget {
  const UpdatePasswordDialog({Key? key}) : super(key: key);

  @override
  _UpdatePasswordDialogState createState() => _UpdatePasswordDialogState();
}

class _UpdatePasswordDialogState extends State<UpdatePasswordDialog> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> updatePassword() async {
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final email = user.email!;

      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPasswordController.text);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong.";
      if (e.code == 'wrong-password') {
        message = "Current password is incorrect.";
      } else if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Password"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Current Password"),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (value.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    updatePassword();
                  }
                },
          child: isLoading
              ? const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Update"),
        ),
      ],
    );
  }
}
