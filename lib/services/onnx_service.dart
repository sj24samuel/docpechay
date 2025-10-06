import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:onnxruntime/onnxruntime.dart';

class OnnxService {
  static final OnnxService _instance = OnnxService._internal();
  factory OnnxService() => _instance;
  OnnxService._internal();

  OrtSession? _session;
  bool _modelLoaded = false;
  List<String> _labels = [];

  /// ✅ Load ONNX model
  Future<void> loadModel() async {
    if (_modelLoaded) return;

    try {
      final bytes = await rootBundle.load('assets/mobilenet_pechay_modelv2.onnx');
      final modelBytes = bytes.buffer.asUint8List();

      // ✅ Updated API usage
      final sessionOptions = OrtSessionOptions();
      _session = await OrtSession.fromBuffer(modelBytes, sessionOptions);

      final labelsData = await rootBundle.loadString('assets/petchay_labels.txt');
      _labels = labelsData.split('\n').where((e) => e.isNotEmpty).toList();

      _modelLoaded = true;
      debugPrint("✅ ONNX model loaded successfully!");
    } catch (e, s) {
      debugPrint("❌ ERROR loading ONNX model: $e");
      debugPrint("$s");
    }
  }

  /// ✅ Detect disease from CameraImage
  Future<Map<String, dynamic>> detectDisease(CameraImage image) async {
    if (!_modelLoaded || _session == null) {
      return {'label': 'Model not loaded', 'confidence': 0.0};
    }

    try {
      // 1️⃣ Convert YUV → RGB
      final rgb = _convertYUV420toImage(image);

      // 2️⃣ Resize to 224x224
      final resized = img.copyResize(rgb, width: 224, height: 224);

      // 3️⃣ Convert to Float32 tensor
      final inputTensor = _preprocessImage(resized);

      // 4️⃣ Create OrtValueTensor
      final inputOrt = OrtValueTensor.createTensorWithDataList(
        inputTensor,
        [1, 3, 224, 224],
      );

      // ✅ 5️⃣ Run model with proper Map<String, OrtValueTensor>
      // Replace "input" and "output" with your actual names from the ONNX model
      final outputs = await _session!.run(
        OrtRunOptions(),     // <--- first argument: options
        {'input': inputOrt}, // <--- second argument: map of inputs
      );

      // 6️⃣ Extract the output tensor
      final outputOrt = outputs[0];
      final outputData = outputOrt?.value as List<double>?;

      if (outputData == null || outputData.isEmpty) {
        return {'label': 'No output data', 'confidence': 0.0};
      }

      // 7️⃣ Find the class with highest confidence
      int maxIndex = 0;
      double maxConfidence = outputData[0];
      for (int i = 1; i < outputData.length; i++) {
        if (outputData[i] > maxConfidence) {
          maxConfidence = outputData[i];
          maxIndex = i;
        }
      }

      // 8️⃣ Return result
      return {
        'label': _labels.isNotEmpty ? _labels[maxIndex] : 'Class $maxIndex',
        'confidence': maxConfidence,
      };
    } catch (e, s) {
      debugPrint("❌ ERROR during inference: $e");
      debugPrint("$s");
      return {'label': 'Detection error', 'confidence': 0.0};
    }
  }


  /// ✅ Dispose session
  Future<void> dispose() async {
    try {
      _session?.release();
      _modelLoaded = false;
      debugPrint("🧹 ONNX session released.");
    } catch (e) {
      debugPrint("❌ Error closing ONNX session: $e");
    }
  }

  /// Convert YUV420 → RGB
  img.Image _convertYUV420toImage(CameraImage image) {
    final width = image.width;
    final height = image.height;

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
        final int uvIndex = uvRowStride * (y >> 1) + uvPixelStride * (x >> 1);

        final yp = image.planes[0].bytes[y * width + x];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];

        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        imgRgb.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return imgRgb;
  }

  /// Normalize and flatten image into Float32
  List<double> _preprocessImage(img.Image image) {
    final input = List<double>.filled(3 * 224 * 224, 0.0);
    int i = 0;
    for (int c = 0; c < 3; c++) {
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = image.getPixel(x, y);
          final value = (c == 0
                  ? pixel.r
                  : c == 1
                      ? pixel.g
                      : pixel.b) /
              255.0;
          input[i++] = value;
        }
      }
    }
    return input;
  }
}
