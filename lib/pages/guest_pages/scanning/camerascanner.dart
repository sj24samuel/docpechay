import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:docpechayapp/pages/guest_pages/scanning/result_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool isDetecting = false;
  bool isCapturing = false;
  bool _modelLoaded = false;
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
    _cameraController = CameraController(cameras.first, ResolutionPreset.medium);

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
          double newConfidence = result['confidence'] ?? 0.0;

          // Only update if confidence changes significantly
          if ((newConfidence - detectionConfidence).abs() > 0.05) {
            setState(() {
              detectionResult = result['label'] ?? "Unknown";
              detectionConfidence = newConfidence;
            });
          }
        }

        await Future.delayed(const Duration(milliseconds: 300));
        isDetecting = false;
      }
    });
  }

Future<void> _loadModel() async {
  if (_modelLoaded) return; // Prevent multiple loads
  _modelLoaded = true; // Set flag

  try {
    debugPrint("LOG: Loading TFLite model...");
    String? res = await Tflite.loadModel(
      model: "assets/bokchoymodel.tflite",
      labels: "assets/petchay_labels.txt",
    );
    debugPrint("LOG: Model loaded result: $res");
  } catch (e, s) {
    debugPrint("ERROR: Failed to load TFLite model: $e");
    debugPrint("$s");
  }
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

    setState(() => isCapturing = true);

    try {
      XFile file = await _cameraController!.takePicture();

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
          const SnackBar(content: Text("Failed to capture image.")),
        );
      }
    } finally {
      setState(() => isCapturing = false);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Disease Scanner"),
        backgroundColor: Colors.green,
      ),
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? Stack(
              children: [
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
                Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Detected: $detectionResult (${(detectionConfidence * 100).toStringAsFixed(1)}%)",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera),
                      label: const Text("Capture", style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: isCapturing ? null : _captureImage,
                    ),
                  ),
                ),
                if (isCapturing)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
