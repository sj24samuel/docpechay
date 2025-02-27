import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                'assets/images/FAQ.gif', // Path to local image asset
                height: 185,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const QuestionWithAnswer(
                question: 'What is this application about?',
                answer:
                    'This application is designed to detect common diseases in Pechay (Chinese cabbage) using image recognition powered by a Convolutional Neural Network (CNN). It provides users with accurate disease detection and suggests appropriate treatment options.',
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'Who can use this application?',
                answer:
                    'The app is intended for farmers, agricultural experts, and plant industry professionals, especially those working with Pechay crops. It is also suitable for anyone seeking to monitor the health of their plants.',
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'Is this Reliable?',
                answer:
                    'Yes the app is Reliable'
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'What are the diseases that the app can detect?',
                answer:
                    'The Disease that the app can detect are Altenaira Leaf Spot, Bacterial Spot, Downy Mildew and as well a Healthy Pechay Crop'
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'How do I use the disease detection feature?  ',
                answer:
                    'You simply need to take or upload a clear picture of the Pechay plant’s affected area. The app will analyze the image using its CNN model and return a diagnosis along with treatment recommendations.'  
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'How accurate is the disease detection?',
                answer:
                    'The application uses a Convolutional Neural Network trained with a large dataset of Pechay disease images. Accuracy may vary based on the quality of the image and the disease, but the model has been trained to ensure high precision in detecting the most common diseases.'  
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'What kind of treatment recommendations does the app provide?',
                answer:
                    'Once the disease is identified, the app suggests effective and practical treatments. These may include the use of organic or chemical treatments, cultivation techniques, or environmental adjustments to help manage the disease.'
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'Can I use the app without an internet connection?',
                answer:
                    'Yes, the application is designed to work offline. The disease detection and treatment recommendation features are available without requiring an internet connection, allowing users in remote areas to utilize the app seamlessly.'
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'How can I ensure the app works optimally?',
                answer:
                    'Make sure to provide clear and well-lit images of the affected Pechay plant. Blurry or obstructed images may reduce the accuracy of detection.'
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'Is this app available for both Android and iOS?',
                answer:
                    'The app is currently available for Android users only. iOS support is not yet provided.'
              ),
              const SizedBox(height: 16),
              const QuestionWithAnswer(
                question: 'Who developed this application?',
                answer:
                    'This app was developed by BSIT students from Leyte Normal University in collaboration with the Bureau of Plant Industry, using advanced machine learning techniques like Convolutional Neural Networks to enhance agricultural technology.'
              ),
              const SizedBox(height: 16),

              // Add more questions here if needed
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionWithAnswer extends StatefulWidget {
  final String question;
  final String answer;

  const QuestionWithAnswer({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  State<QuestionWithAnswer> createState() => _QuestionWithAnswerState();
}

class _QuestionWithAnswerState extends State<QuestionWithAnswer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.answer,
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FAQ(),
  ));
}
