import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final String recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "• $recommendation",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
/*
List<String> _getRecommendations(String disease) {
    Map<String, List<String>> recommendations = {
      "Black Rot": [
        "Remove infected leaves immediately.",
        "Use copper-based fungicides to control spread.",
        "Ensure proper spacing between plants for airflow."
      ],
      "Downy Mildew": [
        "Avoid overhead watering to prevent moisture buildup.",
        "Apply organic fungicides like neem oil.",
        "Rotate crops to prevent disease recurrence."
      ],
      "Leaf Spot": [
        "Use disease-resistant plant varieties.",
        "Keep foliage dry to prevent fungal growth.",
        "Apply sulfur-based fungicides if necessary."
      ],
      "No disease detected": [
        "Your plant looks healthy!",
        "Regularly inspect for any changes in leaves.",
        "Maintain proper watering and fertilization."
      ]
    };

    return recommendations[disease] ?? ["No specific recommendations available."];
  }
*/