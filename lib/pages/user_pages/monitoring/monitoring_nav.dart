import 'package:docpechayapp/pages/user_pages/monitoring/monitor_dashboard.dart';
import 'package:flutter/material.dart';
import 'monitoring_page.dart';
//import 'community_scanned.dart';

void main() {
  runApp(const MonitoringNav());
}

class MonitoringNav extends StatelessWidget {
  const MonitoringNav({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      home:  MonitoringDashboard(),
      routes: {
        '/monitoring_page': (context) => const MonitoringPage(),
       // '/community_scanned': (context) => const CommunityScannedPage(),
      },
    );
  }
}
