import 'package:docpechayapp/pages/diseasepages/alternaria.dart';
import 'package:docpechayapp/pages/diseasepages/bacterial.dart';
import 'package:docpechayapp/pages/diseasepages/blackrot.dart';
import 'package:docpechayapp/pages/diseasepages/downymildew.dart';
import 'package:flutter/material.dart';

class glossary_index extends StatefulWidget {
  const glossary_index({super.key});

  @override
  State<glossary_index> createState() => _glossary_indexState();
}

class _glossary_indexState extends State<glossary_index> {
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
                        'Disease Database',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/diseasepics/Alternaria.jfif', // Path to local image asset
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Alternaria Leaf Spot',
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
                          'Lesions on leaves start as small, dark spots that gradually enlarge and turn brown to gray with concentric zones resembling that of a target.  Lesions may have purplish or blackish border, chlorotic halo is evident if surrounding area of the leaf is still green. ',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: ElevatedButton.icon(
                            onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => alternaria_disease()));
                          },
                          icon: const Icon(Icons.info),
                          label: const Text("Learn More",
                          style: TextStyle(color: Colors.black)),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(
                              const  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          )
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
                      'assets/images/diseasepics/bacterial.jfif', // Path to local image asset
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Bacterial Soft Rot',
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
                          'This disease thrives in warm, humid climates and is most serious in tropical, subtropical, and humid continental regions.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: ElevatedButton.icon(
                            onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => bacterial_disease()));
                          },
                          icon: const Icon(Icons.info),
                          label: const Text("Learn More",
                          style: TextStyle(color: Colors.black)),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(
                              const  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          )
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
                      'assets/images/diseasepics/blackrot.jfif', // Path to local image asset
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Black Rot',
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
                          'Infected plants first exhibit 1-3 cm of irregular, dull yellow lesions along the leaf margins that expands towards the midrib creating a V-shaped lesion with broad yellow margin and dry brown center.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: ElevatedButton.icon(
                            onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => blackrot_disease()));
                          },
                          icon: const Icon(Icons.info),
                          label: const Text("Learn More",
                          style: TextStyle(color: Colors.black)),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(
                              const  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          )
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
                      'assets/images/diseasepics/DSC_0324.jfif', // Path to local image asset
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Downy Mildew',
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
                          'Leaf symptoms appear as yellowish, irregular lesions on the upper surface corresponding to a white fluffy or downy growth develops on the undersides of leaves.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: ElevatedButton.icon(
                            onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => downymildew_disease()));
                          },
                          icon: const Icon(Icons.info),
                          label: const Text("Learn More",
                          style: TextStyle(color: Colors.black)),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(
                              const  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          )
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

//end of code
/*
class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );

  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const  EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ), 
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}*/
