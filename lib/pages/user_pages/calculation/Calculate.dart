import 'package:flutter/material.dart';

class Calculate extends StatefulWidget {
  // ignore: use_super_parameters
  const Calculate({Key? key}) : super(key: key);

  @override
  State<Calculate> createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  final TextEditingController _hectaresControllerf = TextEditingController();
  final TextEditingController _hectaresControllerp = TextEditingController();
  String _resultf = '';
  String _resultp = '';

  //Fertlizer Radio Button
  // ignore: non_constant_identifier_names
  String _SelectedFertilizer = 'Urea';
  final Map<String, double> _fertRec = {
    'Urea': 0.015,
    'Complete': 0.03,
    'Ammonium Nitrate': 0.012,
  };

  //Pesticide Radio Button
  // ignore: non_constant_identifier_names
  String _SelcetedPesticide = 'Metalaxyl';
  final Map<String, double> _pestRec = {
    'Metalaxyl': 0.004,
    'Mancozeb': 0.003,
    'Lime': 0.3,
    'Chlorothalonil': 0.003,
  };

  double _frecamount = 0.0;


  void _calculatef() {
    // Logic to calculate the amount based on hectares
    double hectares = double.tryParse(_hectaresControllerf.text) ?? 0;
    // Example calculation (you can replace it with your own logic)
    double amount = hectares * _fertRec[_SelectedFertilizer]!; // Example calculation
    _frecamount = amount;
    setState(() {
      _resultf = 'Approx. Total amount of fertilizer needed: $_frecamount Kg \n Half will be alocated for initial pre-planting and half will be use for foliar maintance every 2 - 3 weeks';
    });
  }

  double _frecamountp = 0.0;

    void _calculatep() {
    // Logic to calculate the amount based on hectares
    double hectares = double.tryParse(_hectaresControllerp.text) ?? 0;
    // Example calculation (you can replace it with your own logic)
    double amount = hectares * _pestRec[_SelcetedPesticide]!; // Example calculation
    _frecamountp =  amount; 
    setState(() {
      _resultp = 'Approx. Total amount of Pesticide needed in Foliar/Soil Application: $_frecamountp kg ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center( child: Text('Treatment Calculation',
          style: TextStyle(fontSize: 25,)
        ),),
      ),
      body: Center(
        //height: 300, // Adjust the height as needed
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Fertilizer
                      const Text('Fertilizer Calculation', 
                      style: TextStyle(fontSize: 20, fontFamily: 'Arial'),
                      textAlign:TextAlign.center,
                      ),
                      TextField(
                        controller: _hectaresControllerf,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Enter Approx. Area in Sq.M',
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Fertilizer Type of Substance',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      //Radio Button
                      ListTile(
                        title: const Text('Urea'),
                        leading: Radio<String>(
                          value: 'Urea',
                          groupValue: _SelectedFertilizer,
                          onChanged: (String? value) {
                            setState(() {
                              _SelectedFertilizer = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Complete'),
                        leading: Radio<String>(
                          value: 'Complete',
                          groupValue: _SelectedFertilizer,
                          onChanged: (String? value) {
                            setState(() {
                              _SelectedFertilizer = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Ammonium Nitrate'),
                        leading: Radio<String>(
                          value: 'Ammonium Nitrate',
                          groupValue: _SelectedFertilizer,
                          onChanged: (String? value) {
                            setState(() {
                              _SelectedFertilizer = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _calculatef,
                        child: const Text('Calculate'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _resultf,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Image.asset(
                        'assets/images/calculate.gif', // Path to local image asset
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Pesticides calculator
                      const SizedBox(height: 10),
                      const Text('Pesticides Calculation', 
                      style: TextStyle(fontSize: 20, fontFamily: 'Arial'),
                      textAlign:TextAlign.center,
                      ),
                      TextField(
                        controller: _hectaresControllerp,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Enter Approx. Area in Sq.M',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Pesticide Substance',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      //Radio Pesticides
                      ListTile(
                        title: const Text('Metalaxyl'),
                        leading: Radio<String>(
                          value: 'Metalaxyl',
                          groupValue: _SelcetedPesticide,
                          onChanged: (String? value) {
                            setState(() {
                              _SelcetedPesticide = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Mancozeb'),
                        leading: Radio<String>(
                          value: 'Mancozeb',
                          groupValue: _SelcetedPesticide,
                          onChanged: (String? value) {
                            setState(() {
                              _SelcetedPesticide = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Lime'),
                        leading: Radio<String>(
                          value: 'Lime',
                          groupValue: _SelcetedPesticide,
                          onChanged: (String? value) {
                            setState(() {
                              _SelcetedPesticide = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Chlorothalonil'),
                        leading: Radio<String>(
                          value: 'Chlorothalonil',
                          groupValue: _SelcetedPesticide,
                          onChanged: (String? value) {
                            setState(() {
                              _SelcetedPesticide = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _calculatep,
                        child: const Text('Calculate'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _resultp,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Image.asset(
                        'assets/images/calculate.gif', // Path to local image asset
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hectaresControllerf.dispose();
    super.dispose();
  }

}