import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MonitoringDashboard extends StatefulWidget {
  @override
  _MonitoringDashboardState createState() => _MonitoringDashboardState();
}

class _MonitoringDashboardState extends State<MonitoringDashboard> {
  Map<String, int> diseaseCounts = {};
  List<FlSpot> scanTrends = [];
  List<String> monthLabels = [];
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
      Map<String, int> scansPerMonth = {};

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('disease') && data['disease'] != null) {
          String disease = data['disease'];
          Timestamp? timestamp = data['timestamp'];
          
          counts[disease] = (counts[disease] ?? 0) + 1;
          
          if (timestamp != null) {
            String monthKey = DateFormat('yyyy-MM').format(timestamp.toDate());
            scansPerMonth[monthKey] = (scansPerMonth[monthKey] ?? 0) + 1;
          }
        }
      }

      List<String> sortedMonths = scansPerMonth.keys.toList()..sort();
      Map<String, double> monthIndices = {
        for (int i = 0; i < sortedMonths.length; i++) sortedMonths[i]: i.toDouble()
      };

      setState(() {
        diseaseCounts = counts;
        scanTrends = sortedMonths
            .map((month) => FlSpot(monthIndices[month]!, scansPerMonth[month]!.toDouble()))
            .toList();
        monthLabels = sortedMonths.map((m) {
          DateTime parsedDate = DateTime.parse("${m}-01");
          return DateFormat.MMM().format(parsedDate);
        }).toList();
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
                Expanded(
                  child: SizedBox(
                    height: 500, // Set a fixed height to prevent overflow
                    child: CarouselSlider(
                      items: [
                        buildPieChart(),
                        buildBarChart(),
                        buildLineChart(),
                      ],
                      options: CarouselOptions(
                        height: 500, // Match the SizedBox height
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                    ),
                  ),
                ),

                buildNavigationCard(context, "My Past Scanned", "View your past scanned diseases.", '/monitoring_page'),
                buildNavigationCard(context, "Community Scanned", "View all users' scanned diseases.", '/community_scanned'),
              ],
            ),
    );
  }

  Widget buildPieChart() {
    if (diseaseCounts.isEmpty) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pechay Disease Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(height: 20),
              Text("No data available", style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    List<Color> chartColors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal
    ];

    int totalCases = diseaseCounts.values.fold(0, (sum, value) => sum + value);
    if (totalCases == 0) return SizedBox(); // Prevent division by zero

    List<MapEntry<String, int>> diseaseList = diseaseCounts.entries.toList();

    return SizedBox(
      height: 300, // Ensure it fits in the carousel
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pechay Disease Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
              SizedBox(height: 10),
              Expanded( // Ensures the chart resizes within the available space
                child: Column(
                  children: [
                    SizedBox(
                      width: 250, // Adjust width if needed
                      height: 250, // Adjust height to prevent overflow
                      child: PieChart(
                        PieChartData(
                          sections: diseaseList.asMap().entries.map((entry) {
                            int index = entry.key;
                          int percentage = ((entry.value.value / totalCases) * 100).round(); // Rounded integer 
                            return PieChartSectionData(
                              value: entry.value.value.toDouble(),
                              title: "$percentage%", // Show percentage
                              color: chartColors[index % chartColors.length],
                              radius: 60, // Reduce radius to fit inside carousel
                              titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft, // Move labels to bottom-left
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: diseaseList.asMap().entries.map((entry) {
                          int index = entry.key;
                          String disease = entry.value.key;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: chartColors[index % chartColors.length],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(disease, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          Text("No. of Every Diseases", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            height: 300, // Adjusted height to fit content properly
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Transform.rotate(
                          angle: -0.5, // Rotate labels for readability
                          child: Text(diseaseCounts.keys.elementAt(value.toInt())),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // Adjusts spacing for labels
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(value.toInt().toString(), style: TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide right axis
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide top axis
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.black, width: 1), // Y-axis
                    bottom: BorderSide(color: Colors.black, width: 1), // X-axis
                  ),
                ),
                barGroups: diseaseCounts.entries.map((entry) {
                  return BarChartGroupData(
                    x: diseaseCounts.keys.toList().indexOf(entry.key),
                    barRods: [
                      BarChartRodData(toY: entry.value.toDouble(), color: Colors.blue),
                    ],
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


  Widget buildLineChart() {
    if (scanTrends.isEmpty) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("My Scan Timeline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("No scan data available.", style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("My Scan Timeline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                    getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(right: 12.0), // Added margin for "Scan Count"
                        child: Text("Scan Count", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5.0), // Adjust spacing
                            child: Text(value.toInt().toString(), style: TextStyle(fontSize: 12)),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide right numbers
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide top numbers
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          return index >= 0 && index < monthLabels.length
                              ? Text(monthLabels[index], style: TextStyle(fontSize: 12))
                              : Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.black, width: 1), // Y-axis (Left)
                      bottom: BorderSide(color: Colors.black, width: 1), // X-axis (Bottom)
                    ),
                  ),
                  minX: scanTrends.first.x,
                  maxX: scanTrends.last.x,
                  minY: 0, // Start scan count from 0
                  maxY: scanTrends.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: scanTrends,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
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

  Widget buildNavigationCard(BuildContext context, String title, String subtitle, String route) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
