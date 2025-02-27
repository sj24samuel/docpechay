import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:docpechayapp/pages/result_page.dart';

class Camerascanner extends StatefulWidget {
  const Camerascanner({super.key});

  @override
  State<Camerascanner> createState() => _CamerascannerState();
}

class _CamerascannerState extends State<Camerascanner> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool isDetecting = false;
  String? detectionResult;
  double? detectionConfidence;
  Map<String, dynamic>? _boundingBox;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0], // Use back camera
      ResolutionPreset.medium,
    );

    await _cameraController?.initialize();
    if (!mounted) return;

    setState(() {});
    _startCameraStream();
  }

  void _startCameraStream() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (!isDetecting) {
        isDetecting = true;

        var result = await _detectDisease(image);
        if (mounted) {
          setState(() {
            detectionResult = result['label'] ?? "Unknown";
            detectionConfidence = result['confidence'] ?? 0.0;
            _boundingBox = result['box']; // Bounding box
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
      rotation: 90, // Fix rotation
      numResults: 1,
      threshold: 0.3,
      asynch: true,
    );

    if (results != null && results.isNotEmpty) {
      var result = results.first;
      return {
        'label': result['label'],
        'confidence': result['confidence'],
        'box': result['rect']
      };
    }
    return {'label': 'No disease detected', 'confidence': 0.0, 'box': null};
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        XFile file = await _cameraController!.takePicture();

        // Navigate to Result Page
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                detectionResult: detectionResult ?? "Unknown",
                detectionConfidence: detectionConfidence ?? 0.0,
                capturedImage: file, // Pass the captured image
              ),
            ),
          );
        }
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
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
        title: const Text(
          "Pechay Disease Detection",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 218, 18),
      ),
      body: Column(
        children: [
          // Camera Preview (Fixed Orientation)
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Center(
                  child: Transform.rotate(
                    angle: 90 * (3.1415926535897932 / 180), // Rotate camera preview
                    child: CameraPreview(_cameraController!),
                  ),
                ),

                // Bounding Box
                if (_boundingBox != null)
                  Positioned(
                    left: _boundingBox!['x'] * MediaQuery.of(context).size.width,
                    top: _boundingBox!['y'] * MediaQuery.of(context).size.height,
                    width: _boundingBox!['w'] * MediaQuery.of(context).size.width,
                    height: _boundingBox!['h'] * MediaQuery.of(context).size.height,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 3),
                      ),
                    ),
                  ),

                // Detection Result Overlay
                Positioned(
                  bottom: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      detectionResult != null
                          ? "$detectionResult\nConfidence: ${(detectionConfidence ?? 0.0 * 100).toStringAsFixed(2)}%"
                          : "Detecting...",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Capture Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: _captureImage,
              child: const Icon(Icons.camera),
            ),
          ),
        ],
      ),
    );
  }
}
