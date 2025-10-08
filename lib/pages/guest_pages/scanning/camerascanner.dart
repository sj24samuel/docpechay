import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:docpechayapp/pages/guest_pages/scanning/result_page.dart';
import 'package:docpechayapp/services/onnx_service.dart';

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

  final _onnxService = OnnxService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _onnxService.loadModel();
    setState(() => _modelLoaded = true);
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
    if (_cameraController == null) return;

    _cameraController!.startImageStream((CameraImage image) async {
      if (!_modelLoaded || isDetecting) return;
      isDetecting = true;

      try {
        // Perform ONNX inference
        final result = await _onnxService.detectDisease(image);

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
      } catch (e) {
        debugPrint("ONNX detection error: $e");
      } finally {
        await Future.delayed(const Duration(milliseconds: 300));
        isDetecting = false;
      }
    });
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
    _onnxService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Disease Scanner"),
        backgroundColor: Colors.green,
      ),
      body: !_modelLoaded
          ? const Center(child: CircularProgressIndicator())
          : _cameraController != null && _cameraController!.value.isInitialized
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
