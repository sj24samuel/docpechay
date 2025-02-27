import 'package:flutter/material.dart';

class blackrot_disease extends StatefulWidget {
  const blackrot_disease({super.key});

  @override
  State<blackrot_disease> createState() => _blackrot_diseaseState();
}

class _blackrot_diseaseState extends State<blackrot_disease> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diseases Glossary"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Black Rot',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/diseasepics/blackrot.jfif', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    //Characteristic Symptoms
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Characteristic Symtoms',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Infected plants first exhibit 1-3 cm of irregular, dull yellow lesions along the leaf margins that expands towards the midrib creating a V-shaped lesion with broad yellow margin and dry brown center.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Leaves defoliate and vascular tissues become dark',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    //Conditions
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Characteristic Symtoms',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- The pathogen infects a wide range of brassica crops  and weeds',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Warm, humid conditions and temperatures not exceeding 25°C are favorable for the bacterial growth',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Early infection of seedlings can result in severe stunting and plant death',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Infected transplants, seedbeds, heavy rain or overhead sprinkler/ irrigation water can rapidly spread the bacteria many meters from the infected plant',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- The pathogen is seedborne and can survive on plant debris and in the soil',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Infection is more likely to occur before transplanting, during late flowering and seed maturation',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    //Management and Control
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Management and Control',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          '- Use of pathogen-free seeds',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Hot water treatment of suspected seed lots at 50 °C (25 min for cabbage, broccoli and Brussels; 15 min for cauliflower, kohlrabi, kale, turnip and rutabaga)',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Strict field sanitation and monitoring for early symptoms',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Remove infected plants from seedbeds and close monitoring of the remaining plants',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Avoid overhead watering and furrow irrigation',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Disinfection of tools and equipment after use',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Remove volunteer and weedy crucifers that may serve as alternate hosts for the pathogen.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Spray with protective copper-based fungicides (e.g. Cupravit®, Vitigran Blue®, Nordox 50®).',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                    //Refference
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Refferences:\n Agriculture and Natural Resources Publication, FSA7549. Diseases of Turnip and Mustard Greens,\n https://www.uaex.edu/publications/PDF/FSA-7549.pdf \n Compendium of Brassica Diseases by APS (2007)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
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
}