import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class EyeDoctorList extends StatefulWidget {
  const EyeDoctorList({Key? key}) : super(key: key);

  @override
  _EyeDoctorListState createState() => _EyeDoctorListState();
}

class _EyeDoctorListState extends State<EyeDoctorList> {
  DatabaseReference doctorDb = FirebaseDatabase.instance.ref("EyeDoctors");
  Query doctorQuery = FirebaseDatabase.instance.ref().child('EyeDoctors');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Doctors List'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FirebaseAnimatedList(
          query: doctorQuery,
          defaultChild: const Center(child: CircularProgressIndicator()),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map doctor = snapshot.value as Map;
            doctor['key'] = snapshot.key;
            return doctorCard(doctor: doctor);
          },
        ),
      ),
      backgroundColor: Colors.lightBlue[50],
    );
  }

  Widget doctorCard({required Map doctor}) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetails(
                doctorName: doctor['dname'],
                specialization: doctor['specialization'],
                experience: doctor['years_of_experience'],
                location: doctor['hospital_location'],
                doctorImage: doctor['image'],
                doctorKey: doctor['key'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: doctor['image'] != null && doctor['image'] != ""
                    ? Image.network(
                  doctor['image'],
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.person, size: 120, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                doctor['dname'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                doctor['specialization'],
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                "Experience: ${doctor['years_of_experience']} years",
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              Text(
                doctor['hospital_location'],
                style: const TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorDetails extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String experience;
  final String location;
  final String doctorImage;
  final String doctorKey;

  const DoctorDetails({
    Key? key,
    required this.doctorName,
    required this.specialization,
    required this.experience,
    required this.location,
    required this.doctorImage,
    required this.doctorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctorName),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: doctorImage.isNotEmpty
                  ? Image.network(
                doctorImage,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.person, size: 200, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              "Specialization: $specialization",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Experience: $experience years",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Hospital: $location",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.lightBlue[50],
    );
  }
}
