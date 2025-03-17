import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ResultPage extends StatefulWidget {
  final String detectionResult;
  final double detectionConfidence;
  final String imageUrl;
  final XFile? capturedImage;

  const ResultPage({Key? key,
    required this.detectionResult,
    required this.detectionConfidence,
    required this.imageUrl,
    this.capturedImage, Position? position,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Position? _currentPosition;
  bool _isSaving = false; // Track if saving is in progress

  @override
  void initState() {
    super.initState();
    _getLocationAndSaveResult();
  }

  // Get GPS location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permissions are permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });

    debugPrint("Location: ${position.latitude}, ${position.longitude}");
  }

  // Save detection result and location to Firestore
  Future<void> _saveResultToFirestore() async {
    if (_currentPosition == null) {
      debugPrint("Skipping Firestore save because location is null.");
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('detection_results').add({
        'disease': widget.detectionResult,
        'confidence': widget.detectionConfidence,
        'imagePath': widget.capturedImage?.path ?? "No image",
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Detection result saved to Firestore with location.");
    } catch (e) {
      debugPrint("Error saving result: $e");
    }

    setState(() {
      _isSaving = false;
    });
  }

  // Get location and then save result
  Future<void> _getLocationAndSaveResult() async {
    await _getCurrentLocation();
    if (_currentPosition != null) {
      await _saveResultToFirestore();
    }
  }

  // Generate recommendations based on the detected disease
  List<String> _getRecommendations(String disease) {
    Map<String, List<String>> recommendations = {
      "Black Rot": [
        "Remove infected leaves immediately.",
        "Use copper-based fungicides to control spread.",
        "Ensure proper spacing between plants for airflow."
      ],
      "Downy Mildew": [
        "Avoid overhead watering to prevent moisture buildup.",
        "Apply organic fungicides like neem oil.",
        "Rotate crops to prevent disease recurrence."
      ],
      "Leaf Spot": [
        "Use disease-resistant plant varieties.",
        "Keep foliage dry to prevent fungal growth.",
        "Apply sulfur-based fungicides if necessary."
      ],
      "No disease detected": [
        "Your plant looks healthy!",
        "Regularly inspect for any changes in leaves.",
        "Maintain proper watering and fertilization."
      ]
    };

    return recommendations[disease] ?? ["No specific recommendations available."];
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
            if (widget.capturedImage != null)
              Image.file(
                File(widget.capturedImage!.path),
                height: 250,
              )
            else
              const Text("No image captured"),

            const SizedBox(height: 20),

            // Detection Result
            Text(
              "Disease: ${widget.detectionResult}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Confidence: ${(widget.detectionConfidence * 100).toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // GPS Coordinates Display
            _currentPosition != null
                ? Text(
                    "Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  )
                : const Text("Fetching GPS location..."),

            const SizedBox(height: 20),

            // Recommendations Section
            const Text(
              "Recommendations",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._getRecommendations(widget.detectionResult).map(
              (rec) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "• $rec",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Saving Indicator
            if (_isSaving) const CircularProgressIndicator(),

            // Back Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Scanner"),
            ),
          ],
        ),
      ),
    );
  }
}
