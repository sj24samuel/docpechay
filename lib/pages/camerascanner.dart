import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'result_page.dart';

class CameraScanner extends StatefulWidget {
  const CameraScanner({super.key});

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool isDetecting = false;
  String detectionResult = "Detecting...";
  double detectionConfidence = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );

    await _cameraController?.initialize();
    if (!mounted) return;
    setState(() {});
    _startImageStream();
  }

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (!isDetecting) {
        isDetecting = true;
        var result = await _detectDisease(image);
        if (mounted) {
          setState(() {
            detectionResult = result['label'] ?? "Unknown";
            detectionConfidence = result['confidence'] ?? 0.0;
          });
        }
        await Future.delayed(const Duration(milliseconds: 500));
        isDetecting = false;
      }
    });
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: "assets/bokchoymodel.tflite",
      labels: "assets/petchay_labels.txt",
    );
  }

  Future<Map<String, dynamic>> _detectDisease(CameraImage image) async {
    var results = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 1,
      threshold: 0.3,
      asynch: true,
    );

    if (results != null && results.isNotEmpty) {
      var result = results.first;
      return {
        'label': result['label'],
        'confidence': result['confidence'],
      };
    }
    return {'label': 'No disease detected', 'confidence': 0.0};
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      XFile file = await _cameraController!.takePicture();
      Position? position = await _getCurrentLocation();
      String imageUrl = await _uploadImage(File(file.path));

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              detectionResult: detectionResult,
              detectionConfidence: detectionConfidence,
              imageUrl: imageUrl,
              position: position,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error capturing image: $e");
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = "images/${const Uuid().v4()}.jpg";
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return "";
    }
  }

  Future<Position?> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint("Location services are disabled.");
    return null;
  }

  // Check location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint("Location permission denied.");
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    debugPrint("Location permission is permanently denied.");
    return null;
  }

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  } catch (e) {
    debugPrint("Failed to get location: $e");
    return null;
  }
}


  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pechay Disease Scanner"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),

          // Detection Result Overlay
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$detectionResult\nConfidence: ${(detectionConfidence * 100).toStringAsFixed(2)}%",
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Capture Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: _captureImage,
                child: const Icon(Icons.camera_alt, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
