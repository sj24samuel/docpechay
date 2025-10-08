import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class RoboflowService {
  final String roboflowApiKey;
  final String roboflowModel;
  final String roboflowVersion;

  RoboflowService({
    required this.roboflowApiKey,
    required this.roboflowModel,
    required this.roboflowVersion,
  });

  // Upload image to Firebase Storage and get download URL
  Future<String> uploadImageToFirebase(File imageFile, String fileName) async {
    final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  // Send image to Roboflow for detection
  Future<Map<String, dynamic>> detectPechay(String imageUrl) async {
    final endpoint =
        'https://detect.roboflow.com/$roboflowModel/$roboflowVersion?api_key=$roboflowApiKey';
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': imageUrl}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Roboflow detection failed: ${response.body}');
    }
  }
}