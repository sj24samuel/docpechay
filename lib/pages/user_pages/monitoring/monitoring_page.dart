import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'detection_detail_page.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  String searchQuery = "";

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
              List<DocumentSnapshot> filteredRecords = monthRecords.where((doc) {
                Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
                String disease = (record['disease'] ?? "").toLowerCase();
                return disease.contains(searchQuery.toLowerCase());
              }).toList();

              return StickyHeader(
                header: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  color: Colors.green.shade300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 35,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search disease...",
                              hintStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.search, color: Colors.white),
                              filled: true,
                              fillColor: Colors.green.shade500,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 5),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          // Add sorting/filtering logic if needed
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: "Sort by Date", child: Text("Sort by Date")),
                          const PopupMenuItem(value: "Sort by Confidence", child: Text("Sort by Confidence")),
                        ],
                      ),
                    ],
                  ),
                ),
                content: Column(
                  children: filteredRecords.isNotEmpty
                      ? filteredRecords.map((doc) {
                          Map<String, dynamic> record = doc.data() as Map<String, dynamic>;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text("Disease: ${record['disease'] ?? 'Unknown'}"),
                              subtitle: Text(
                                "Confidence: ${(record['confidence'] * 100).toStringAsFixed(2)}%\n"
                                "Date: ${record.containsKey('timestamp') ? (record['timestamp'] as Timestamp).toDate().toLocal().toString().split(' ')[0] : 'N/A'}",
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
