import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'detection_detail_page.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring Page"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('detection_results')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No scanned records found."));
          }

          var data = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enables horizontal scrolling
            child: DataTable(
              columnSpacing: 12.0,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.green.shade200),
              border: TableBorder.all(color: Colors.black12),
              columns: const [
                DataColumn(label: Text("Image")),
                DataColumn(label: Text("Disease")),
                DataColumn(label: Text("Confidence")),
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Details")),
              ],
              rows: data.map((doc) {
                Map<String, dynamic> record = doc.data() as Map<String, dynamic>;

                return DataRow(cells: [
                  DataCell(
                    record.containsKey('imagePath') && record['imagePath'] != "No image"
                        ? Image.file(File(record['imagePath']), width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported),
                  ),
                  DataCell(Text(record['disease'] ?? "Unknown")),
                  DataCell(Text("${(record['confidence'] * 100).toStringAsFixed(2)}%")),
                  DataCell(Text(record.containsKey('timestamp')
                      ? (record['timestamp'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
                      : "N/A")),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetectionDetailPage(detectionData: record),
                          ),
                        );
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
