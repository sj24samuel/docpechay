import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  String? _imageUrl;
  List<String> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _processResult();
  }

  Future<void> _processResult() async {
    await Future.wait([
      _getCurrentLocation(),
      _uploadImage(),
      _fetchRecommendations(),
    ]);
    if (_currentPosition != null && _imageUrl != null) {
      await _saveResultToFirestore();
    }
  }

  Future<void> _getCurrentLocation() async {
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
          desiredAccuracy: LocationAccuracy.high);

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _isFetchingLocation = false;
      });

    } catch (e) {
      debugPrint("Error fetching location: $e");
      _showErrorDialog("Failed to get location. Try again.");
    }
  }

  Future<void> _uploadImage() async {
    if (widget.capturedImage == null) return;

    try {
      File imageFile = File(widget.capturedImage!.path);
      String fileName = "detection_${DateTime.now().millisecondsSinceEpoch}.jpg";

      Reference ref = FirebaseStorage.instance.ref().child('scanned_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      if (!mounted) return;
      setState(() {
        _imageUrl = imageUrl;
      });

    } catch (e) {
      debugPrint("Error uploading image: $e");
      _showErrorDialog("Failed to upload image. Please try again.");
    }
  }

  Future<void> _fetchRecommendations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('disease_info')
          .where('disease_name', isEqualTo: widget.detectionResult)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        List<String> recommendations = List<String>.from(data['control'].values);

        if (!mounted) return;
        setState(() {
          _recommendations = recommendations;
        });
      } else {
        setState(() {
          _recommendations = ["No specific recommendations available."];
        });
      }
    } catch (e) {
      debugPrint("Error fetching recommendations: $e");
      _showErrorDialog("Failed to fetch recommendations. Try again.");
    }
  }

  Future<void> _saveResultToFirestore() async {
    setState(() => _isSaving = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("User not logged in");
        return;
      }

      await FirebaseFirestore.instance.collection('detection_results').add({
        'userId': user.uid,
        'userEmail': user.email,
        'disease': widget.detectionResult,
        'confidence': widget.detectionConfidence,
        'imageUrl': _imageUrl,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      debugPrint("Detection result saved successfully.");
    } catch (e) {
      debugPrint("Error saving result: $e");
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
              child: _imageUrl != null
                  ? Image.network(_imageUrl!, height: 250, width: double.infinity, fit: BoxFit.cover)
                  : widget.capturedImage != null
                      ? Image.file(File(widget.capturedImage!.path), height: 250, width: double.infinity, fit: BoxFit.cover)
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

            const SizedBox(height: 16),

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
            ),

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
                        Text(
                          "Recommendations",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    const Divider(),
                    _recommendations.isNotEmpty
                        ? Column(
                            children: _recommendations.map((rec) => ListTile(
                                  leading: const Icon(Icons.check_circle, color: Colors.green),
                                  title: Text(rec, style: const TextStyle(fontSize: 16)),
                                )).toList(),
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
