import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseDetectionPage extends StatefulWidget {
  const DiseaseDetectionPage({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionPage> createState() => _DiseaseDetectionPageState();
}

class _DiseaseDetectionPageState extends State<DiseaseDetectionPage> {
  File? _imageFile;
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _uploadedImageUrl;

  final ImagePicker _picker = ImagePicker();

  // 🔹 Pick image from camera
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
      _result = null;
    });

    await _uploadAndDetect();
  }

  // 🔹 Upload image to Firebase Storage
  Future<String> _uploadToFirebase(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // 🔹 Call Roboflow API
  Future<Map<String, dynamic>?> _detectDisease(String imageUrl) async {
    const String apiKey = "dK5UJXQ3f7EGzJdxc4GD";
    const String model = "pechaydiseasemodel-kt1tc/2"; // model/version

    // Use the detect.roboflow.com endpoint instead of serverless
    final uri = Uri.parse(
        "https://detect.roboflow.com/$model?api_key=$apiKey&image=$imageUrl");

    final response = await http.get(uri);

    print("Roboflow response (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // Roboflow sometimes returns { "predictions": [] } or { "output": { "predictions": [] } }
      if (decoded.containsKey('output')) {
        return decoded['output'];
      }
      return decoded;
    } else {
      print("Error: ${response.statusCode}");
      print(response.body);
      return null;
    }
  }

  // 🔹 Upload to Firebase and detect
  Future<void> _uploadAndDetect() async {
    if (_imageFile == null) return;

    setState(() {
      _loading = true;
    });

    try {
      // 1️⃣ Upload to Firebase
      final imageUrl = await _uploadToFirebase(_imageFile!);
      print("🔗 Firebase image URL: $imageUrl");
      setState(() {
        _uploadedImageUrl = imageUrl;
      });

      // 2️⃣ Send to Roboflow
      final result = await _detectDisease(imageUrl);
      if (result != null) {
        setState(() {
          _result = result;
        });

        // 3️⃣ Save result to Firestore
        await FirebaseFirestore.instance.collection('detections').add({
          'imageUrl': imageUrl,
          'result': result,
          'timestamp': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // 🔹 Display detection results
  Widget _buildResultView() {
    print("Roboflow result: $_result");
    if (_result == null) {
      return const Text('No result yet.');
    }

    final predictions = _result!['predictions'];
    if (predictions.isEmpty) {
      return const Text('No disease detected.');
    }

    final prediction = predictions[0];
    final disease = prediction['class'];
    final confidence =
        (prediction['confidence'] * 100).toStringAsFixed(1) + '%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          'Detected Disease:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          disease,
          style: TextStyle(fontSize: 22, color: Colors.green[700]),
        ),
        const SizedBox(height: 8),
        Text('Confidence: $confidence'),
        const SizedBox(height: 16),
        if (_uploadedImageUrl != null)
          Image.network(
            _uploadedImageUrl!,
            height: 250,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pechay Disease Detection"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imageFile != null)
                  Image.file(_imageFile!, height: 250, fit: BoxFit.cover)
                else
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.camera_alt, size: 80),
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(_loading ? "Processing..." : "Capture Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                if (_loading) const CircularProgressIndicator(),
                const SizedBox(height: 20),
                _buildResultView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
