import 'package:flutter/material.dart';

class HomeRemediesPage extends StatefulWidget {
  const HomeRemediesPage({Key? key}) : super(key: key);

  @override
  _HomeRemediesPageState createState() => _HomeRemediesPageState();
}

class _HomeRemediesPageState extends State<HomeRemediesPage> {
  final List<String> remedies = [
    'Hair',
    'Skin',
    'Eyes',
    'Respiratory illnesses',
    'Toothache',
    'Heartburn',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Remedies'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200], // Set the background color to light gray
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    hint: Text('Choose an option'),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black), // Set the icon color to black
                    iconSize: 24,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    dropdownColor: Colors.grey[200], // Set the dropdown menu color to light gray
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });

                      // Add navigation logic here based on the selected value
                      // Example:
                      // if (selectedValue == 'Hair') {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => HairRemediesPage()),
                      //   );
                      // }
                    },
                    items: remedies.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, // Set the text color to black
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 80),
              // Add your other widgets here
              ElevatedButton(
                onPressed: () {
                  // Add your appointment booking logic here
                },
                child: Text('Select home remedies'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
