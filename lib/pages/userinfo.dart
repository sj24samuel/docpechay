import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoPage extends StatelessWidget {
  final String userId;

  const UserInfoPage({super.key, required this.userId, required Map<String, dynamic> userData});

  Future<DocumentSnapshot?> getUserInfo() async {
    try {
      return await FirebaseFirestore.instance.collection('user').doc(userId).get();
    } catch (e) {
      print("❌ Firestore error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: FutureBuilder<DocumentSnapshot?>(
        future: getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No profile found!"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userData['profilePicUrl'] != null
                        ? NetworkImage(userData['profilePicUrl'])
                        : null,
                    child: userData['profilePicUrl'] == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text("Name: ${userData['firstName']} ${userData['middleInitial'] ?? ''} ${userData['lastName']}",
                    style: const TextStyle(fontSize: 18)),
                Text("Age: ${userData['age']}", style: const TextStyle(fontSize: 18)),
                Text("Sex: ${userData['sex']}", style: const TextStyle(fontSize: 18)),
                Text("Email: ${userData['email']}", style: const TextStyle(fontSize: 18)),
                Text("Address: ${userData['address']}", style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
