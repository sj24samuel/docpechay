import 'package:docpechayapp/pages/camerascanner.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class Scanner1 extends StatefulWidget {
  const Scanner1({super.key});

  @override
  State<Scanner1> createState() => _Scanner1State();
}

class _Scanner1State extends State<Scanner1> {
  late ImagePicker _imagePicker;
  XFile? _pickedImage;
  List<dynamic>? _recognitions1;
  bool _isLoading = false;
  late String res;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeTflite();
    _imagePicker = ImagePicker();
  }

  Future<void> _initializeTflite() async {
    try {
      res = (await Tflite.loadModel(
        model: "assets/bokchoymodel.tflite",
        labels: "assets/petchay_labels.txt",
        isAsset: true,
        useGpuDelegate: false,
      ))!;
      print(res);
    } catch (e) {
      print('Error initializing TFLite: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
        _recognitions1 = null; // Clear previous recognitions
        _isLoading = true;
      });
      await _processImage();
    }
  }

  Future<void> _processImage() async {
    if (_isProcessing || _pickedImage == null) return;
    _isProcessing = true;

    try {
      final List<dynamic>? recognitions = await Tflite.runModelOnImage(
        path: _pickedImage!.path,
        numResults: 1,
        threshold: 0.5,
        asynch: true,
      );

      setState(() {
        _recognitions1 = recognitions;
      });
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Pechay Scanner",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          if (!_isLoading) ...[
            Image.asset(
              'assets/images/uploading.gif',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
          ],
          if (!_isLoading && _pickedImage != null)
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Image.file(
                File(_pickedImage!.path),
                fit: BoxFit.cover,
              ),
            )
          else if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Container(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Camerascanner()));
            },
            label: const Text("Scan my Pechay", style: TextStyle(color: Colors.black)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickImageFromCamera,
            label: const Text("Take a Picture", style: TextStyle(color: Colors.black)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_recognitions1 != null)
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      "Details:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 86, 54, 244),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _recognitions1!
                          .map(
                            (recognition) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Label: ${recognition['label']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "Confidence Level: ${(recognition['confidence'] * 100).toStringAsFixed(2)}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  ..._getRecommendationCards(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _getRecommendationCards() {
    final Map<String, List<String>> recommendations = {
      'Alternaria Leaf Spot': [
        "Remove infected leaves immediately to prevent spreading.",
        "Apply fungicide as per manufacturer's instructions.",
        "Ensure proper ventilation and reduce humidity around plants."
      ],
      'Bacterial Soft Rot': [
        "Avoid overhead watering to minimize moisture on leaves.",
        "Apply copper-based fungicide to affected plants.",
        "Ensure proper plant spacing for adequate airflow."
      ],
      'Healthy Pechay': [
        "Maintain regular care for healthy growth.",
        "Use appropriate fertilizers.",
        "Monitor for pests or diseases."
      ],
      'Black Rot': [
        "Use resistant plant varieties.",
        "Remove and destroy infected plants.",
        "Sanitize tools and equipment."
      ],
      'Downy Mildew': [
        "Apply fungicides before symptoms appear.",
        "Improve air circulation.",
        "Reduce leaf wetness."
      ],
      'Unknown Object': [
        "Ensure the image is of a leaf.",
        "Avoid blurry or unclear images.",
        "Provide a clear view of the object."
      ],
    };

    if (_recognitions1 == null || !_recognitions1![0].containsKey('label')) {
      return [];
    }

    final label = _recognitions1![0]['label'];
    final recommendationList = recommendations[label];

    if (recommendationList == null) {
      return [];
    }

    return [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommendations for $label:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            ...recommendationList.map((recommendation) => Text(
                  recommendation,
                  style: const TextStyle(fontSize: 15),
                )),
          ],
        ),
      )
    ];
  }

  @override
  void dispose() {
    Tflite.close().catchError((e) {
      print('Error closing TFLite: $e');
    });
    super.dispose();
  }
}

class Scannermain extends StatelessWidget {
  const Scannermain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pechay Scanner",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 218, 18),
      ),
      body: const Scanner1(),
    );
  }
}
