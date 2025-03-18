import 'package:flutter/material.dart';
import 'dart:io';

class DetectionDetailPage extends StatelessWidget {
  final Map<String, dynamic> detectionData;

  const DetectionDetailPage({super.key, required this.detectionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Details"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detection Summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display Image if `imagePath` exists
            detectionData.containsKey('imagePath') && detectionData['imagePath'] != "No image"
                ? Image.file(File(detectionData['imagePath']), height: 250)
                : const Text("No image available", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            Text(
              "Disease: ${detectionData['disease']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              "Confidence: ${(detectionData['confidence'] * 100).toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // GPS Coordinates Display
            detectionData.containsKey('latitude') && detectionData.containsKey('longitude')
                ? Text(
                    "Location: ${detectionData['latitude']}, ${detectionData['longitude']}",
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  )
                : const Text("No location data available"),

            const SizedBox(height: 30),

            // Back Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
