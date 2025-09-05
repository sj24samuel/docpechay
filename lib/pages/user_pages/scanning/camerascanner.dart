import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'result_page.dart';

class CameraScanner extends StatefulWidget {
  const CameraScanner({super.key});

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;

  Interpreter? _interpreter;
  bool isDetecting = false;
  String detectionResult = "Detecting...";
  double detectionConfidence = 0.0;
  bool isCapturing = false;

  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _loadLabels() async {
    final labelData = await rootBundle.loadString('assets/petchay_labels.txt');
    _labels = labelData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    debugPrint("✅ Labels loaded: $_labels");
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _cameraController?.initialize();
      if (!mounted) return;
      setState(() {});
      _startImageStream();
    } catch (e) {
      debugPrint("❌ Error initializing camera: $e");
    }
  }

  Future<void> _loadModel() async {
    try {
      final options = InterpreterOptions();
      // Use the appropriate delegate for your model if needed.
      // For the Flex ops issue, you need to add the dependency
      // 'org.tensorflow:tensorflow-lite-select-tf-ops' in Android.
      _interpreter = await Interpreter.fromAsset('assets/model(Sept 2025).tflite', options: options);
      debugPrint("✅ Model loaded");

      // Print model input/output info
      var inputShape = _interpreter!.getInputTensor(0).shape;
      var inputType = _interpreter!.getInputTensor(0).type;
      var outputShape = _interpreter!.getOutputTensor(0).shape;
      debugPrint("📏 Input shape: $inputShape, type: $inputType");
      debugPrint("📏 Output shape: $outputShape");
    } catch (e) {
      debugPrint("❌ Failed to load model: $e");
    }
  }

  void _startImageStream() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _cameraController?.startImageStream((CameraImage image) async {
      if (!isDetecting && _interpreter != null) {
        isDetecting = true;

        try {
          var result = await _detectDisease(image);
          if (mounted) {
            setState(() {
              detectionResult = result['label'];
              detectionConfidence = result['confidence'];
            });
          }
        } catch (e) {
          debugPrint("❌ Error in image stream: $e");
          if (mounted) {
            setState(() {
              detectionResult = "Error";
              detectionConfidence = 0.0;
            });
          }
        } finally {
          // Delay to prevent overwhelming the device
          await Future.delayed(const Duration(milliseconds: 300));
          isDetecting = false;
        }
      }
    });
  }

  Future<Map<String, dynamic>> _detectDisease(CameraImage image) async {
    // Check if the interpreter and labels are ready
    if (_interpreter == null || _labels.isEmpty) {
      return {'label': 'Loading...', 'confidence': 0.0};
    }

    try {
      // 1. Convert YUV420 → RGB
      final rgbImage = _convertYUV420toImage(image);
      if (rgbImage == null) {
        throw Exception("Failed to convert image format");
      }

      // 2. Resize to 224x224
      final resized = img.copyResize(rgbImage, width: 224, height: 224);

      // 3. Normalize & prepare input tensor
      var input = List.generate(
        1,
        (i) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resized.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );

      // 4. Prepare output buffer
      var output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);

      // 5. Run inference
      _interpreter!.run(input, output);

      // 6. Get results
      final probs = List<double>.from(output[0]);
      final bestIdx = probs.indexOf(probs.reduce((a, b) => a > b ? a : b));

      final label = (bestIdx < _labels.length) ? _labels[bestIdx] : 'Unknown';
      final confidence = probs[bestIdx];

      return {'label': label, 'confidence': confidence};
    } catch (e) {
      debugPrint("❌ Error during detection: $e");
      return {'label': 'Error', 'confidence': 0.0};
    }
  }

  img.Image? _convertYUV420toImage(CameraImage image) {
    // This is a complex but necessary conversion.
    // The previous code had a solid implementation.
    // We'll keep it as-is but add a null check for safety.
    try {
      final int width = image.width;
      final int height = image.height;
      final yBuffer = image.planes[0].bytes;
      final uBuffer = image.planes[1].bytes;
      final vBuffer = image.planes[2].bytes;

      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel!;

      final outImage = img.Image(width: width, height: height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
          final int index = y * width + x;

          final yp = yBuffer[index];
          final up = uBuffer[uvIndex];
          final vp = vBuffer[uvIndex];

          int r = (yp + 1.402 * (vp - 128)).round().clamp(0, 255);
          int g = (yp - 0.344136 * (up - 128) - 0.714136 * (vp - 128)).round().clamp(0, 255);
          int b = (yp + 1.772 * (up - 128)).round().clamp(0, 255);

          outImage.setPixelRgba(x, y, r, g, b, 255);
        }
      }
      return outImage;
    } catch (e) {
      debugPrint("❌ YUV conversion error: $e");
      return null;
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() => isCapturing = true);

    try {
      XFile file = await _cameraController!.takePicture();
      File imageFile = File(file.path);

      Position? position = await _getCurrentLocation();
      String imageUrl = await _uploadImage(imageFile);

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
      debugPrint("❌ Error capturing image: $e");
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
      debugPrint("❌ Error uploading image: $e");
      return "";
    }
  }

  Future<Position?> _getCurrentLocation() async {
    // Location permission handling remains the same
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _interpreter?.close();
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
          Positioned.fill(child: CameraPreview(_cameraController!)),
          // Bounding Box Overlay
          _buildBoundingBoxOverlay(),
          // Detection result and capture button
          Positioned(
            bottom: 180,
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
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: isCapturing
                  ? const CircularProgressIndicator()
                  : FloatingActionButton(
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

// Simple placeholder for bounding box. Your model does not provide this.
// A classification model only predicts a label, not a location.
Widget _buildBoundingBoxOverlay() {
  return Container();
}