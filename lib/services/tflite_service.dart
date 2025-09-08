import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  Interpreter? _interpreter;
  bool _modelLoaded = false;

  List<String> _labels = [];

  /// ✅ Load model once
  Future<void> loadModel() async {
    if (_modelLoaded) return;
    try {
      _interpreter = await Interpreter.fromAsset('bokchoymodel.tflite');

      final labelsData = await rootBundle.loadString('assets/petchay_labels.txt');

      _labels = labelsData.split('\n').where((e) => e.isNotEmpty).toList();

      _modelLoaded = true;
      debugPrint("LOG: Model loaded ✅");
    } catch (e, s) {
      debugPrint("ERROR: Failed to load TFLite model: $e");
      debugPrint("$s");
    }
  }

  /// ✅ Detect disease from CameraImage
  Future<Map<String, dynamic>> detectDisease(CameraImage image) async {
    if (!_modelLoaded || _interpreter == null) {
      return {'label': 'Model not loaded', 'confidence': 0.0};
    }

    try {
      // 1. Convert YUV420 → RGB
      final imgRgb = _convertYUV420toImage(image);

      // 2. Resize to 224x224
      final resized = img.copyResize(imgRgb, width: 224, height: 224);

      // 3. Convert to normalized float [224,224,3]
      final inputImage = _imageToFloat32List(resized);

      // 4. Build batch [32,224,224,3] → repeat same image
      final input = List.generate(32, (_) => inputImage);

      // 5. Allocate output [32,6]
      final output = List.generate(32, (_) => List.filled(6, 0.0));

      // 6. Run inference
      _interpreter!.run(input, output);

      // 7. Take first prediction [6]
      final prediction = output[0];

      // 8. Find best class index
      int maxIndex = 0;
      double maxConfidence = prediction[0];
      for (int i = 1; i < prediction.length; i++) {
        if (prediction[i] > maxConfidence) {
          maxConfidence = prediction[i];
          maxIndex = i;
        }
      }

      return {
        'label': _labels.isNotEmpty ? _labels[maxIndex] : "Class $maxIndex",
        'confidence': maxConfidence,
      };
    } catch (e, s) {
      debugPrint("ERROR during detection: $e");
      debugPrint("$s");
      return {'label': 'Detection error', 'confidence': 0.0};
    }
  }

  /// ✅ Close model safely
  Future<void> dispose() async {
    try {
      _interpreter?.close();
      _modelLoaded = false;
      debugPrint("LOG: TFLite model closed.");
    } catch (e) {
      debugPrint("ERROR closing TFLite: $e");
    }
  }

  /// 🔹 Convert YUV420 (CameraImage) → RGB
  img.Image _convertYUV420toImage(CameraImage image) {
    final width = image.width;
    final height = image.height;

    // Empty RGBA image
    final imgRgb = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: Uint8List(width * height * 4).buffer,
      order: img.ChannelOrder.rgba,
    );

    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex =
            uvRowStride * (y >> 1) + uvPixelStride * (x >> 1);

        final yp = image.planes[0].bytes[y * width + x];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];

        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        imgRgb.setPixelRgba(x, y, r, g, b, 255); // add alpha
      }
    }

    return imgRgb;
  }




  List<List<List<double>>> _imageToFloat32List(img.Image image) {
    return List.generate(
      224,
      (y) => List.generate(
        224,
        (x) {
          final pixel = image.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        },
      ),
    );
  }


}
