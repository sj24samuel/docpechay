import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

class ResultPage extends StatefulWidget {
  final String detectionResult;
  final double detectionConfidence;
  final XFile? capturedImage;

  const ResultPage({
    Key? key,
    required this.detectionResult,
    required this.detectionConfidence,
    this.capturedImage,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Position? _currentPosition;
  bool _isSaving = false;
  bool _isFetchingLocation = true;
  List<String> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _processResult();
  }

  Future<void> _processResult() async {
    await Future.wait([
      //_getCurrentLocation(),
      _fetchRecommendations(),
    ]);
    await _saveResultToLocalStorage();
  }

  /*Future<void> _getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showErrorDialog("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog("Location permission is required.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog("Location permissions are permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _isFetchingLocation = false;
      });
    } catch (e) {
      debugPrint("Error fetching location: $e");
      _showErrorDialog("Failed to get location. Try again.");
    }
  }*/

  Future<void> _fetchRecommendations() async {
    await Future.delayed(const Duration(seconds: 1)); // mock delay
    setState(() {
      _recommendations = [
        "Use organic pesticides.",
        "Avoid overwatering.",
        "Ensure proper sunlight exposure."
      ];
    });
  }

  Future<void> _saveResultToLocalStorage() async {
    setState(() => _isSaving = true);
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/detection_results.json';

      File file = File(filePath);
      List<dynamic> results = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        results = jsonDecode(content);
      }

      final newResult = {
        'disease': widget.detectionResult,
        'confidence': widget.detectionConfidence,
        'imagePath': widget.capturedImage?.path,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      };

      results.add(newResult);
      await file.writeAsString(jsonEncode(results), flush: true);

      _showSuccessDialog("Result saved to local storage.");
    } catch (e) {
      debugPrint("Error saving locally: $e");
      _showErrorDialog("Failed to save locally.");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Result"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Detection Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.capturedImage != null
                  ? Image.file(
                      File(widget.capturedImage!.path),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Text("No image available", style: TextStyle(fontSize: 16)),
                    ),
            ),

            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.info, color: Colors.green),
                title: Text("Disease: ${widget.detectionResult}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("Confidence: ${(widget.detectionConfidence * 100).toStringAsFixed(2)}%", style: const TextStyle(fontSize: 16)),
              ),
            ),

            /*const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: _isFetchingLocation
                    ? const Text("Fetching location...", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic))
                    : _currentPosition != null
                        ? Text("${_currentPosition!.latitude}, ${_currentPosition!.longitude}", style: const TextStyle(fontSize: 16))
                        : const Text("Location unavailable"),
              ),
            ),*/

            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Recommendations", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    const Divider(),
                    _recommendations.isNotEmpty
                        ? Column(
                            children: _recommendations
                                .map((rec) => ListTile(
                                      leading: const Icon(Icons.check_circle, color: Colors.green),
                                      title: Text(rec, style: const TextStyle(fontSize: 16)),
                                    ))
                                .toList(),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("No recommendations available.", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                          ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            if (_isSaving) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
