import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docpechayapp/pages/user_profile/editprofilepage.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  final String uid;
  UserInfoPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Information")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No user data found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userData['profile_picture'] != null && userData['profile_picture'] != ""
                        ? NetworkImage(userData['profile_picture'])
                        : null,
                    child: userData['profile_picture'] == null || userData['profile_picture'] == ""
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Text("Name: ${userData['first_name']} ${userData['middle_initial']}. ${userData['last_name']}", style: TextStyle(fontSize: 18)),
                Text("Age: ${userData['age']}", style: TextStyle(fontSize: 18)),
                Text("Sex: ${userData['sex']}", style: TextStyle(fontSize: 18)),
                Text("Address: ${userData['address']}", style: TextStyle(fontSize: 18)),
                Text("Email: ${userData['email']}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(uid: uid)));
                    },
                    child: Text("Edit Profile"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
