import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'result_page.dart';

class CameraScanner_guest extends StatefulWidget {
  const CameraScanner_guest({super.key});

  @override
  State<CameraScanner_guest> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner_guest> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool isDetecting = false;
  String detectionResult = "Detecting...";
  double detectionConfidence = 0.0;
  bool isCapturing = false; // ✅ New: Track when capturing

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);

    await _cameraController?.initialize();
    await _loadModel(); // Ensure model is loaded before streaming

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
          double newConfidence = result['confidence'] ?? 0.0;
          
          // Only update if confidence changes significantly
          if ((newConfidence - detectionConfidence).abs() > 0.05) {
            setState(() {
              detectionResult = result['label'] ?? "Unknown";
              detectionConfidence = newConfidence;
            });
          }
        }
        await Future.delayed(const Duration(milliseconds: 300)); // Less delay
        isDetecting = false;
      }
    });
  }

  bool _modelLoaded = false;

  Future<void> _loadModel() async {
    if (_modelLoaded) return; // Prevent multiple loads
    _modelLoaded = true; // Set flag
    await Tflite.loadModel(
      model: "assets/bokchoymodel.tflite",
      labels: "assets/petchay_labels.txt",
    );
  }

  Future<Map<String, dynamic>> _detectDisease(CameraImage image) async {
    try {
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
    } catch (e) {
      debugPrint("Error during detection: $e");
    }

    return {'label': 'No disease detected', 'confidence': 0.0};
  }


  Future<void> _captureImage() async {
  if (_cameraController == null || !_cameraController!.value.isInitialized) return;

  setState(() => isCapturing = true); // Show loading

  try {
    XFile file = await _cameraController!.takePicture();
    File imageFile = File(file.path);
    Position? position = await _getCurrentLocation();
    String imageUrl = await _uploadImage(imageFile);

    if (imageUrl.isEmpty) {
      throw Exception("Image upload failed");
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            detectionResult: detectionResult,
            detectionConfidence: detectionConfidence,
            capturedImage: file,
          ),
        ),
      );
    }
  } catch (e) {
    debugPrint("Error capturing image: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture image. Please try again.")),
      );
    }
  } finally {
    setState(() => isCapturing = false);
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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location Required"),
            content: const Text("Please enable location services to proceed."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


  @override
void dispose() {
  _cameraController?.stopImageStream(); // Stop the stream before closing the model
  _cameraController?.dispose();
  Tflite.close(); // Close the model safely
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
          // ✅ Camera Preview covering most of the screen
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _cameraController!.value.previewSize!.height,
                height: _cameraController!.value.previewSize!.width,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),
          ),


          // ✅ Detection result box
          Positioned(
            bottom: 180, // ✅ Adjusted position
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$detectionResult\nConfidence: ${(detectionConfidence * 100).toStringAsFixed(2)}%",
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // ✅ Capture Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: isCapturing ? null : _captureImage, // ✅ Disable button while capturing
                    child: const Icon(Icons.camera_alt, size: 32),
                  ),
                  if (isCapturing)
                    const CircularProgressIndicator(), // ✅ Show loading when capturing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
