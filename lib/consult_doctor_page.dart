import 'package:flutter/material.dart';

import 'booking_page.dart';

class ConsultDoctorPage extends StatefulWidget {
  const ConsultDoctorPage({super.key});

  @override
  _ConsultDoctorPageState createState() => _ConsultDoctorPageState();
}

class _ConsultDoctorPageState extends State<ConsultDoctorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consult a Doctor Page'),

      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingPage()),
            );

          },
          child: Text('Book appointment'),
        ),
      ),



    );
  }
}
