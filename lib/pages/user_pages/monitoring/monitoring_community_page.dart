import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'detection_detail_page.dart';

class MonitoringCommunityPage extends StatefulWidget {
  const MonitoringCommunityPage({super.key});

  @override
  _MonitoringCommunityPageState createState() => _MonitoringCommunityPageState();
}

class _MonitoringCommunityPageState extends State<MonitoringCommunityPage> {
  String searchQuery = "";

  void _showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Search Disease"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Enter disease name...",
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = searchController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Search"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Scans"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
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

          // Group records by month
          Map<String, List<DocumentSnapshot>> groupedData = {};
          for (var doc in data) {
            var record = doc.data() as Map<String, dynamic>;
            String month = record.containsKey('timestamp')
                ? DateFormat("MMMM yyyy").format((record['timestamp'] as Timestamp).toDate())
                : "Unknown";

            if (!groupedData.containsKey(month)) {
              groupedData[month] = [];
            }
            groupedData[month]!.add(doc);
          }

          return ListView.builder(
            itemCount: groupedData.keys.length,
            itemBuilder: (context, index) {
              String month = groupedData.keys.elementAt(index);
              List<DocumentSnapshot> monthRecords = groupedData[month]!;

              // Apply search filter
              List<DocumentSnapshot> filteredRecords = searchQuery.isEmpty
                  ? monthRecords
                  : monthRecords.where((doc) {
                      Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
                      String disease = (record['disease'] ?? "").toLowerCase();
                      return disease.contains(searchQuery.toLowerCase());
                    }).toList();

              return StickyHeader(
                header: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  color: Colors.blue.shade300,
                  child: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                content: Column(
                  children: filteredRecords.isNotEmpty
                      ? filteredRecords.map((doc) {
                          Map<String, dynamic> record = doc.data() as Map<String, dynamic>;

                          // Handle missing values
                          String disease = record['disease'] ?? 'Unknown';
                          double confidence = (record['confidence'] ?? 0) * 100;
                          DateTime? date = record['timestamp'] != null
                              ? (record['timestamp'] as Timestamp).toDate()
                              : null;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text("Disease: $disease"),
                              subtitle: Text(
                                "Confidence: ${confidence.toStringAsFixed(2)}%\n"
                                "Date: ${date != null ? DateFormat('yyyy-MM-dd').format(date) : 'N/A'}",
                              ),
                              trailing: IconButton(
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
                          );
                        }).toList()
                      : [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("No results found.", style: TextStyle(fontSize: 16)),
                          ),
                        ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
