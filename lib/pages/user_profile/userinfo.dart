import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  final String uid;
  UserInfoPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Information")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No user data found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          // ✅ Use null-aware operators (`??`) to avoid null values
          String firstName = userData['first_name'] ?? 'Unknown';
          String middleInitial = userData['middle_initial'] ?? '';
          String lastName = userData['last_name'] ?? 'Unknown';
          String age = userData['age']?.toString() ?? 'N/A';
          String sex = userData['sex'] ?? 'N/A';
          String address = userData['address'] ?? 'N/A';
          String email = userData['email'] ?? 'No Email';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: $firstName ${middleInitial.isNotEmpty ? '$middleInitial.' : ''} $lastName", style: const TextStyle(fontSize: 18)),
                Text("Age: $age", style: const TextStyle(fontSize: 18)),
                Text("Sex: $sex", style: const TextStyle(fontSize: 18)),
                Text("Address: $address", style: const TextStyle(fontSize: 18)),
                Text("Email: $email", style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
