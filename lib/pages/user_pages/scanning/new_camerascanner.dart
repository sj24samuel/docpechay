// import 'package:docpechayapp/pages/result_page.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'package:tflite_v2/tflite_v2.dart';

// class Camerascanner1 extends StatefulWidget {
//   const Camerascanner1({super.key});

//   @override
//   State<Camerascanner1> createState() => _CamerascannerState();
// }

// class _CamerascannerState extends State<Camerascanner1> {
//   CameraController? _cameraController;
//   late List<CameraDescription> cameras;
//   bool isDetecting = false;
//   String? detectionResult;
//   double? detectionConfidence;
//   late String res;
//   List<Map<String, dynamic>>? _recognitions1;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     cameras = await availableCameras();
//     _cameraController = CameraController(
//       cameras[0], // Use back camera
//       ResolutionPreset.medium,
//     );

//     await _cameraController?.initialize();
//     if (!mounted) return;

//     await _cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);

//     setState(() {});
//     _startCameraStream();
//   }


//   void _startCameraStream() {
//     _cameraController?.startImageStream((CameraImage image) async {
//       if (!isDetecting) {
//         isDetecting = true;

//         // Run the machine learning model on the frame
//         var result = await _detectDisease(image);

//     if (mounted) {
//           setState(() {
//             detectionResult = result['label'];
//             detectionConfidence = result['confidence'];
//             _recognitions1 = [result];
//           });
//     }

//         isDetecting = false;
//       }
//     });
//   }

//   Future<void> _loadModel() async {
//     res = (await Tflite.loadModel(
//       model: "assets/bokchoymodel.tflite",
//       labels: "assets/petchay_labels.txt",
//     ))!;
//     print("Model loaded: $res");
//   }
//   Future<void> _captureAndDetect() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }

//     try {
//       XFile picture = await _cameraController!.takePicture();

//       // Run detection on the captured image
//       var results = await _detectDisease(File(picture.path) as CameraImage);

//       // Navigate to result page
//       if (mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResultPage(
//               imagePath: picture.path,
//               detectionResult: results['label'],
//               detectionConfidence: results['confidence'],
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print("Error capturing image: $e");
//     }
//   }

//   Future<Map<String, dynamic>> _detectDisease(CameraImage image) async {
//     print("Running model on frame...");
//     var results = await Tflite.runModelOnFrame(
//       bytesList: image.planes.map((plane) {
//         return plane.bytes;
//       }).toList(),
//       imageHeight: image.height,
//       imageWidth: image.width,
//       imageMean: 127.5, // For normalization if needed
//       imageStd: 127.5, // For normalization if needed
//       rotation: 90,
//       numResults: 1, // Limit number of results
//       threshold: 0.3, // Detection confidence threshold
//       asynch: true,
//     );
//     print('Inference results: $results');
//     if (results != null && results.isNotEmpty) {
//       var result = results.first;
//       return {
//         'label': result['label'],
//         'confidence': result['confidence'],
//       };
//     }
//     return {
//       'label': 'No disease detected',
//       'confidence': 0.0,
//     };
//   }


//   @override
//   void dispose() {
//     _cameraController?.stopImageStream();
//     _cameraController?.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Pechay Disease Detection",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: const Color.fromARGB(255, 98, 218, 18),
//       ),
//       body: Column(
//         children: [
//           // Camera preview section
//           Expanded(
//             flex: 2,
//             child: Stack(
//               children: [
//                 RotatedBox(
//                   quarterTurns: 1, // Adjust this if needed
//                   child: CameraPreview(_cameraController!),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.7),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       detectionResult != null
//                           ? "$detectionResult\nConfidence: ${(detectionConfidence ?? 0.0 * 100).toStringAsFixed(2)}%"
//                           : "Detecting...",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Capture Button
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ElevatedButton.icon(
//                     onPressed: _captureAndDetect,
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Capture & Detect"),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
