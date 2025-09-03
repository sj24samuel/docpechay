import 'package:flutter/foundation.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:camera/camera.dart';

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  bool _modelLoaded = false;

  /// ✅ Load model once
  Future<void> loadModel() async {
    if (_modelLoaded) return;
    _modelLoaded = true;

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

  /// ✅ Detect disease from CameraImage
  Future<Map<String, dynamic>> detectDisease(CameraImage image) async {
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
    } catch (e, s) {
      debugPrint("ERROR during detection: $e");
      debugPrint("$s");
    }

    return {'label': 'No disease detected', 'confidence': 0.0};
  }

  /// ✅ Close model safely
  Future<void> dispose() async {
    try {
      await Tflite.close();
      _modelLoaded = false;
      debugPrint("LOG: TFLite model closed.");
    } catch (e) {
      debugPrint("ERROR closing TFLite: $e");
    }
  }
}
