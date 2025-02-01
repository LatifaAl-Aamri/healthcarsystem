import 'package:flutter/material.dart';
import 'package:healthcarsystem/patient_login_page.dart';
import 'package:healthcarsystem/admin_login_page.dart';
import 'package:healthcarsystem/patient_register.dart';
import 'doctor_login_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Healthcare System'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 70),
            alignment: Alignment.center,
            child: Text(
              'Online Healthcare System',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0D47A1),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF1557B0), // Dark blue color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(150, 40), // Adjusted height and width
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientLogin()),
              );
            },
            child: Text(
              'Patient',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 16, // Decreased font size
              ),
            ),
          ),


          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF1557B0), // Dark blue color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(150, 40), // Adjusted height and width
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorLoginPage()),
              );
            },
            child: Text(
              'Doctor',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 16, // Decreased font size
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF1557B0), // Dark blue color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(150, 40), // Adjusted height and width
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminLoginPage()),
              );
            },
            child: Text(
              'Admin',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 16, // Decreased font size
              ),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/logo.png',
                //alignment: Alignment.center,
                width: 800,
                height: 600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
