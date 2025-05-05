import 'package:flutter/material.dart';

class HomeWidget_guest extends StatelessWidget {
  const HomeWidget_guest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pechay Doctor'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeatureCard(
            context: context,
            title: 'Welcome to Pechay Doctor',
            imagePath: 'assets/images/plant1.jpg',
            description: 'Your friendly doctor to assist you in identifying Pechay diseases.',
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context: context,
            title: 'Key Features',
            imagePath: 'assets/images/Aimage.gif',
            description: 'Our app is designed to help you identify common diseases in Pechay using AI, and guide you on proper treatment.',
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context: context,
            title: 'Pechay Scanner',
            imagePath: 'assets/images/botanist.gif',
            description: 'The Pechay Scanner uses AI to detect common diseases and suggest treatments for your crops.',
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context: context,
            title: 'Treatment Calculator',
            imagePath: 'assets/images/calculate.gif',
            description: 'Calculate the right amount of fertilizer and pesticide based on your crop area.',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String imagePath,
    required String description,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                if (buttonLabel != null && onPressed != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: Text(buttonLabel),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
