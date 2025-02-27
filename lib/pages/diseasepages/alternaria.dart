import 'package:flutter/material.dart';

class alternaria_disease extends StatefulWidget {
  const alternaria_disease({super.key});

  @override
  State<alternaria_disease> createState() => _alternaria_diseaseState();
}

class _alternaria_diseaseState extends State<alternaria_disease> {
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
                        'Alteria Black Spot',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/diseasepics/Alternaria.jfif', // Path to local image asset
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
                          '- Lesions on leaves start as small, dark spots that gradually enlarge and turn brown to gray with concentric zones resembling that of a target.  Lesions may have purplish or blackish border, chlorotic halo is evident if surrounding area of the leaf is still green. ',
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
                          '- All aboveground parts of the plants are affected',
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
                          '- Older plants are more susceptible that the younger ones',
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
                          '- Wet weather conditions, relative humidity above 95% and temperature range of 28-31°C are necessary for spore germination and infection. ',
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
                          '- The pathogen can survive on infected plant debris and on the soil and are spread by wind, rain splashes and runoff water.',
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
                          '- Maintain good field sanitation, remove infected plants/plant parts and dispose properly.',
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
                          '- Crop rotation with non-host crop for at least 3 years to reduce the amount of primary inoculum. ',
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
                          '- Spray with copper-based fungicides (e.g. Cupravit®, Vitigran Blue®, Nordox 50®), Mancozeb (Dithane M-45®) or Chlorothalonil (Daconil 2787®) at the initial onset of the disease.',
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
                          'Refferences: Compendium of Brassica Diseases by APS (2007)',
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