import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

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
  late String res;
  List<Map<String, dynamic>>? _recognitions1;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0], // Use the back camera
      ResolutionPreset.low,
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

        // Run the machine learning model on the frame
        var result = await _detectDisease(image);

        if (mounted) {
          setState(() {
            detectionResult = result['label'];
            detectionConfidence = result['confidence'];
            _recognitions1 = [result];
          });
        }

        isDetecting = false;
      }
    });
  }

  Future<void> _loadModel() async {
    res = (await Tflite.loadModel(
      model: "assets/bokchoymodel.tflite",
      labels: "assets/petchay_labels.txt",
    ))!;
    print("Model loaded: $res");
  }

  Future<Map<String, dynamic>> _detectDisease(CameraImage image) async {
    print("Running model on frame...");
    var results = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5, // For normalization if needed
      imageStd: 127.5, // For normalization if needed
      rotation: 90,
      numResults: 1, // Limit number of results
      threshold: 0.3, // Detection confidence threshold
      asynch: true,
    );
    print('Inference results: $results');
    if (results != null && results.isNotEmpty) {
      var result = results.first;
      return {
        'label': result['label'],
        'confidence': result['confidence'],
      };
    }
    return {
      'label': 'No disease detected',
      'confidence': 0.0,
    };
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

    if (_recognitions1 == null || _recognitions1!.isEmpty || !_recognitions1![0].containsKey('label')) {
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
      ),
    ];
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
          // Camera preview section
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                CameraPreview(_cameraController!),
                Positioned(
                  bottom: 16,
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

          // Recommendations section
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_recognitions1 != null)
                    Card(
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text(
                              "Details:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromARGB(255, 86, 54, 244),
                              ),
                            ),
                          ),
                          ..._recognitions1!.map((recognition) {
                            return ListTile(
                              title: Text(
                                "Label: ${recognition['label']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                "Confidence Level: ${(recognition['confidence'] * 100).toStringAsFixed(2)}%",
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ..._getRecommendationCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 