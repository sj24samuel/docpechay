import 'package:flutter/material.dart';

class bacterial_disease extends StatefulWidget {
  const bacterial_disease({super.key});

  @override
  State<bacterial_disease> createState() => _bacterial_diseaseState();
}

class _bacterial_diseaseState extends State<bacterial_disease> {
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
                        'Bacterial Soft Rot',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/diseasepics/bacterial.jfif', // Path to local image asset
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
                          '- Early symptoms appear as water-soaked lesions and expand rapidly.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '- ',
                                style: TextStyle(fontSize: 18,  color: Colors.black,),
                              ),
                              TextSpan(
                                text: 'P. marginalis',
                                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic,  color: Colors.black,),
                              ),
                              TextSpan(
                                text: ' causes a wet, slimy soft rot and unpleasant smell.',
                                style: TextStyle(fontSize: 18,  color: Colors.black,),
                              ),
                            ],
                          ),
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
                          '- The disease thrives in warm, humid climates and is most serious in tropical, subtropical, and humid continental regions.',
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
                          '- It occurs in the field but more serious during transportation or in the storage.',
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
                          '- It can survive in the soil and the bacteria can spread by insects and by cultural practices such as irrigation and farm equipments/machinery.',
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
                          '- Infection is through damaged areas, often caused by fertilizer burn or hail injury in the ﬁeld, but can be associated with the damage during harvesting.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
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
                        alignment: Alignment.center,
                        child: const Text(
                          '- Use of pathogen-free seeds and implements crop rotation',
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
                          '- Strict field sanitation and monitoring for early symptoms and disinfect the tools and equipment after use.',
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
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Refferences: \nCompendium of Brassica Diseases by APS (2007);\n https://www.uaex.edu/publications/PDF/FSA-7549.pdf; \n https://www.agric.wa.gov.au/broccoli/diseases-vegetable-brassicas?page=0%2C0',
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