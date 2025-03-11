import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  final String firstName;
  final String middleInitial;
  final String lastName;
  final int age;
  final String sex;
  final String email;
  final String address;
  final String profilePicUrl;

  const UserInfoPage({
    super.key,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.email,
    required this.address,
    required this.profilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePicUrl),
            ),
            const SizedBox(height: 16),
            Text(
              "$firstName $middleInitial. $lastName",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Age: $age | Sex: $sex", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: Text(address),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
