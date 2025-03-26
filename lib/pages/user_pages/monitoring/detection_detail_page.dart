import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetectionDetailPage extends StatefulWidget {
  final Map<String, dynamic> detectionData;

  const DetectionDetailPage({super.key, required this.detectionData});

  @override
  _DetectionDetailPageState createState() => _DetectionDetailPageState();
}

class _DetectionDetailPageState extends State<DetectionDetailPage> {
  Map<String, dynamic>? diseaseDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiseaseDetails();
  }

  Future<void> fetchDiseaseDetails() async {
    try {
      String diseaseName = widget.detectionData['disease'];
      print("Fetching disease details for: $diseaseName");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('disease_info')
          .where('disease_name', isEqualTo: diseaseName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          diseaseDetails = querySnapshot.docs.first.data() as Map<String, dynamic>;
          isLoading = false; // Stop loading after fetching data
        });
        print("Disease data found: $diseaseDetails");
      } else {
        setState(() {
          isLoading = false;
        });
        print("No document found for $diseaseName");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching disease details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "N/A";
    if (widget.detectionData.containsKey('timestamp')) {
      DateTime date = (widget.detectionData['timestamp']).toDate();
      formattedDate = DateFormat("MMMM dd, yyyy").format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Details"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text(
                    "Detection Summary",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Display Image
                  widget.detectionData.containsKey('imageUrl') &&
                          widget.detectionData['imageUrl'].isNotEmpty
                      ? Image.network(
                          widget.detectionData['imageUrl'],
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
                            "Disease: ${widget.detectionData['disease']}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Confidence: ${(widget.detectionData['confidence'] * 100).toStringAsFixed(2)}%",
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

                  // GPS Coordinates
                  widget.detectionData.containsKey('latitude') &&
                          widget.detectionData.containsKey('longitude')
                      ? Card(
                          color: Colors.blue.shade100,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Location: ${widget.detectionData['latitude']}, ${widget.detectionData['longitude']}",
                              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : const Text("No location data available"),

                  const SizedBox(height: 20),

                  // Disease Details Section
                  if (diseaseDetails != null) ...[
                    const Text(
                      "Disease Report",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    if (diseaseDetails!['symptoms'] != null)
                      buildInfoCard("Symptoms", diseaseDetails!['symptoms']),

                    if (diseaseDetails!['condition'] != null)
                      buildInfoCard("Condition", diseaseDetails!['condition']),

                    if (diseaseDetails!['control'] != null)
                      buildInfoCard("Control", diseaseDetails!['control']),

                    if (diseaseDetails!['references'] != null)
                      buildInfoCard("References", diseaseDetails!['references']),
                  ] else
                    const Text("No additional disease information available."),

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

  // Function to build a card for disease details
  Widget buildInfoCard(String title, dynamic content) {
    return Card(
      color: Colors.orange.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if (content is Map)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content.entries.map<Widget>((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "${entry.key}: ${entry.value}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              )
            else
              Text(content.toString(), style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
