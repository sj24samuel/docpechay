import 'package:flutter/material.dart';

class downymildew_disease extends StatefulWidget {
  const downymildew_disease({super.key});

  @override
  State<downymildew_disease> createState() => _downymildew_diseaseState();
}

class _downymildew_diseaseState extends State<downymildew_disease> {
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
                        'Downy Mildew',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/diseasepics/DSC_0324.jfif', // Path to local image asset
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
                          '- Leaf symptoms appear as yellowish, irregular lesions on the upper surface corresponding to a white fluffy or downy growth develops on the undersides of leaves.',
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
                          '- Older lesions become dry, turn brown and papery in texture and may cause the entire leaf to drop.',
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
                          '- The head of broccoli and cauliflower curds infected with black spots within or on the surface.',
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
                          '- Downy mildew causes damage from the seedling (cotyledons) to harvesting stage.',
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
                          '- The spore releases in the morning or after sunrise.',
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
                          '- It is spread by the wind although leaf wetness is required for infection. Cool, moist conditions favour the disease.',
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
                          '- The fungus can survive on brassica weeds, in crop debris or soil for several months, even in the absence of a host.',
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
                          '- Plant resistant varieties (if available).',
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
                          '- Plow in old crops as soon as harvesting is completed and ensure all crop residue is decomposed before planting.',
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
                          '- Spray to fruit set with a protectant fungicide. In wet weather and after fruit set, use a systemic fungicide',
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
                          '- Wider space in planting allow better airflow and spray penetration.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          '- Avoid overhead irrigation',
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
                          '- Spray with fungicides such as Mancozeb (Dithane M-45®), Chlorothalonil (Daconil 2787®) or metalaxyl+mancozeb (Ridomil®).',
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
                          'Refferences:\n Agriculture and Natural Resources Publication, FSA7549. Diseases of Turnip and Mustard Greens,\n https://www.uaex.edu/publications/PDF/FSA-7549.pdf \n https://www.agric.wa.gov.au/broccoli/diseases-vegetable-brassicas?page=0%2C1 \n https://www.daf.qld.gov.au/plants/fruit-and-vegetables/a-z-list-of-horticultural-diseases-and-disorders/downy-mildew',
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