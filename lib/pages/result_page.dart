import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class ResultPage extends StatefulWidget {
  final String detectionResult;
  final double detectionConfidence;
  final XFile? capturedImage;

  const ResultPage({
    super.key,
    required this.detectionResult,
    required this.detectionConfidence,
    this.capturedImage,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Position? _currentPosition;

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
  }

  // Get location and then save result
  Future<void> _getLocationAndSaveResult() async {
    await _getCurrentLocation();
    if (_currentPosition != null) {
      await _saveResultToFirestore();
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

            const SizedBox(height: 30),

            // GPS Coordinates Display
            _currentPosition != null
                ? Text(
                    "Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  )
                : const Text("Fetching GPS location..."),

            const SizedBox(height: 30),

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
