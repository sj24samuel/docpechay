import 'package:flutter/material.dart';

class Treatmentbank extends StatefulWidget {
  const Treatmentbank({super.key});

  @override
  State<Treatmentbank> createState() => _TreatmentbankState();
}

class _TreatmentbankState extends State<Treatmentbank> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 10,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Fertilizer Types',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/fertilizerandpesticides/urea_fertilizers.jpg', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Urea Fertilizer (46-0-0)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'urea is widely used in the agriculture sector both as a fertilizer and animal feed additive. The main function of urea fertilizer is to provide the plants with nitrogen to promote green leafy growth. It can make the plants look lush, and its necessary for the photosynthesis of plants.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/fertilizerandpesticides/complete.jpg', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Complete Fertilizer (14-14-14)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'A complete fertilizer is a fertilizer that contains the three main nutrients for plants: nitrogen (N), phosphorus (P), and potassium (K). For example, a fertilizer with the ratio 8-2-12 is complete because it contains 8% nitrogen, 2% phosphorus, and 12% potassium. It is a balanced fertilizer is a type of complete fertilizer that contains equal amounts of nitrogen, phosphorus, and potassium.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/fertilizerandpesticides/ammonium.jpg', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Ammonium Nitrate Fertilizer\n (34-0-0)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Ammonium nitrate is an important fertilizer with NPK rating 34-0-0 (34% nitrogen). It is less concentrated than urea (46-0-0), giving ammonium nitrate a slight transportation disadvantage. Ammonium nitrate's advantage over urea is that it is more stable and does not rapidly lose nitrogen to the atmosphere.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Card(
                elevation: 10,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Pesticides Types',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/fertilizerandpesticides/Metalaxyl.jfif', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Metalaxyl',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Metalaxyl is a systemic fungicide used to control plant diseases caused by Oomycete fungi. It's effective against a number of pathogens, including Pythium, Phytophthora, and several downy mildews. ",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/fertilizerandpesticides/Mancozeb.jfif', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Mancozeb',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Mancozeb is classified as a contact fungicide with preventive activity. It is widely used to control fungal diseases in conifer and fir trees. It is also used to control blight in potatoes. It is also used to protect many other fruit, vegetable, nut, and field crops against a wide spectrum of fungal diseases.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/fertilizerandpesticides/aglime.jpg', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Lime',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Agricultural Lime increases the availability of major nutrients nitrogen, phosphate and potassium by: increasing nitrogen fixing in legumes and free living bacteria. increasing N, P & K release from organic matter through higher microbial activity. releasing phosphate from iron and aluminium.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 10,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/fertilizerandpesticides/Chlorothalonil.jfif', // Path to local image asset
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Chlorothalonil',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Chlorothalonil is a broad-spectrum organochloride pesticide. It is primarily used as a fungicide, bactericide, and nematicide, and has been reported to be effective on a wide range of vegetables and fruit crops. It is also used as a bactericide, nematocide, and mildew-preventing agent in paints.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
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