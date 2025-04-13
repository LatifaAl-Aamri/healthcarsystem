// doctor_home_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat_with_patient_page.dart';

class DoctorHomePage extends StatelessWidget {
  final String doctorKey;
  final String doctorUsername;

  const DoctorHomePage({
    Key? key,
    required this.doctorKey,
    required this.doctorUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseReference chatRef = FirebaseDatabase.instance.ref("chats/$doctorKey");

    return Scaffold(
      appBar: AppBar(title: Text("Doctor Home")),
      body: StreamBuilder(
        stream: chatRef.onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data.snapshot.value == null) {
            return const Center(child: Text("No patient messages yet"));
          }

          Map data = snapshot.data.snapshot.value as Map;
          List<String> patientUsernames = data.keys.cast<String>().toList();



          return ListView.builder(
            itemCount: patientUsernames.length,
            itemBuilder: (context, index) {
              String patient = patientUsernames[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Message from: $patient"),
                  subtitle: const Text("Tap to reply"),
                  trailing: const Icon(Icons.chat_bubble_outline),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatWithPatientPage(
                          doctorKey: doctorKey,
                          patientUsername: patient,
                          doctorUsername: doctorUsername,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
