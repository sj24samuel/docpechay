import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'recommendation_card.dart'; // Import the new widget

class ResultPage extends StatelessWidget {
  final String detectionResult;
  final double detectionConfidence;
  final XFile? capturedImage;

  const ResultPage({
    super.key,
    required this.detectionResult,
    required this.detectionConfidence,
    this.capturedImage,
  });

  // Recommendations based on detected disease
  List<Widget> _getRecommendationCards() {
    final Map<String, List<String>> recommendations = {
      'Alternaria Leaf Spot': [
        "Remove infected leaves immediately to prevent spreading.",
        "Apply fungicide as per manufacturer's instructions.",
        "Ensure proper ventilation and reduce humidity around plants."
      ],
      'Bacterial Soft Rot': [
        "Avoid overhead watering to minimize moisture on leaves.",
        "Apply copper-based fungicide to affected plants.",
        "Ensure proper plant spacing for adequate airflow."
      ],
      'Healthy Pechay': [
        "Maintain regular care for healthy growth.",
        "Use appropriate fertilizers.",
        "Monitor for pests or diseases."
      ],
      'Black Rot': [
        "Use resistant plant varieties.",
        "Remove and destroy infected plants.",
        "Sanitize tools and equipment."
      ],
      'Downy Mildew': [
        "Apply fungicides before symptoms appear.",
        "Improve air circulation.",
        "Reduce leaf wetness."
      ],
      'Unknown Object': [
        "Ensure the image is of a leaf.",
        "Avoid blurry or unclear images.",
        "Provide a clear view of the object."
      ],
    };

    // Get the recommendations for the detected disease
    List<String> tips = recommendations[detectionResult] ?? ["No recommendations available."];

    return tips.map((tip) => RecommendationCard(recommendation: tip)).toList();
  }

  Future<String> uploadImageToFirebase(XFile imageFile) async {
    try {
      // Ensure user is logged in
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: "user-not-signed-in",
          message: "User must be signed in to upload images.",
        );
      }

      File file = File(imageFile.path);
      String fileName = "images/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL(); // Returns image URL
    } catch (e) {
      print("Upload failed: $e");
      return "";
    }
  }

  Future<void> saveDetectionResult(String imageUrl, String disease, double confidence) async {
    try {
      await FirebaseFirestore.instance.collection('detections').add({
        'imageUrl': imageUrl,
        'disease': disease,
        'confidence': confidence,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving result: $e");
    }
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Result"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Detection Summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Show Captured Image
            if (capturedImage != null)
              Image.file(
                File(capturedImage!.path),
                height: 250,
              )
            else
              const Text("No image captured"),

            const SizedBox(height: 20),

            // Detection Result
            Text(
              "Disease: $detectionResult",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Confidence: ${(detectionConfidence * 100).toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            // Recommendations
            const Text(
              "Recommendations:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _getRecommendationCards(),
              ),
            ),
            

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;

                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please log in first!")),
                  );
                  return;
                }

                if (capturedImage != null) {
                  String imageUrl = await uploadImageToFirebase(capturedImage!);
                  if (imageUrl.isNotEmpty) {
                    await saveDetectionResult(imageUrl, detectionResult, detectionConfidence);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Uploaded Successfully!")),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("Upload & Back to Scanner"),
            ),

          ],
        ),
      ),
    );
  }
}
