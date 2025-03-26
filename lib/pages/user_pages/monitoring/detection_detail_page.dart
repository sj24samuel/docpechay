import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetectionDetailPage extends StatelessWidget {
  final Map<String, dynamic> detectionData;

  const DetectionDetailPage({super.key, required this.detectionData});

  @override
  Widget build(BuildContext context) {
    // Format the date if available
    String formattedDate = "N/A";
    if (detectionData.containsKey('timestamp')) {
      DateTime date = (detectionData['timestamp']).toDate();
      formattedDate = DateFormat("MMMM dd, yyyy").format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Details"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Detection Summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display Image from URL
            detectionData.containsKey('imageUrl') && detectionData['imageUrl'].isNotEmpty
                ? Image.network(
                    detectionData['imageUrl'],
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                  )
                : const Text("No image available", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            // Disease Information
            Card(
              color: Colors.green.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Disease: ${detectionData['disease']}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Confidence: ${(detectionData['confidence'] * 100).toStringAsFixed(2)}%",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Date Detected: $formattedDate",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // GPS Coordinates Display
            detectionData.containsKey('latitude') && detectionData.containsKey('longitude')
                ? Card(
                    color: Colors.blue.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Location: ${detectionData['latitude']}, ${detectionData['longitude']}",
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                : const Text("No location data available"),

            const SizedBox(height: 30),

            // Back Button
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Back", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
