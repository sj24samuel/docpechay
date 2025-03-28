import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docpechayapp/pages/user_pages/monitoring/monitoring_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonitoringDashboard extends StatefulWidget {
  @override
  _MonitoringDashboardState createState() => _MonitoringDashboardState();
}

class _MonitoringDashboardState extends State<MonitoringDashboard> {
  Map<String, int> diseaseCounts = {}; // Store disease counts
  List<FlSpot> scanTrends = []; // For line chart
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetectionResults();
  }

  Future<void> fetchDetectionResults() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('detection_results').get();

      Map<String, int> counts = {};
      Map<int, int> scansPerDay = {}; // For Line Chart (Date Trends)

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Check if 'disease_name' exists before accessing
        if (data.containsKey('disease') && data['disease'] != null) {
          String disease = data['disease'];
          Timestamp? timestamp = data['timestamp']; // Ensure timestamp exists

          // Count occurrences of diseases
          counts[disease] = (counts[disease] ?? 0) + 1;

          // Count scans per day (for Line Chart)
          if (timestamp != null) {
            int day = timestamp.toDate().day;
            scansPerDay[day] = (scansPerDay[day] ?? 0) + 1;
          }
        } else {
          print("⚠️ Skipping document ${doc.id} because 'disease' is missing!");
        }
      }

      setState(() {
        diseaseCounts = counts;
        scanTrends = scansPerDay.entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("🔥 Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Monitoring Dashboard")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: buildPieChart()),
                Expanded(child: buildBarChart()),
                Expanded(child: buildLineChart()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context,  '/monitoring_page'),
                        child: Text("Past Scanned"),
                      ),
                      /*ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/community_scanned'),
                        child: Text("Community Scanned"),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildPieChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Disease Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: diseaseCounts.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: entry.key,
                      color: Colors.primaries[diseaseCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBarChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Disease Occurrences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: diseaseCounts.entries.map((entry) {
                    return BarChartGroupData(x: diseaseCounts.keys.toList().indexOf(entry.key), barRods: [
                      BarChartRodData(toY: entry.value.toDouble(), color: Colors.blue),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLineChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Scans Over Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: scanTrends,
                      isCurved: true,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
