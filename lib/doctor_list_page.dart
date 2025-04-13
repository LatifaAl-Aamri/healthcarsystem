import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:healthcarsystem/chat_page.dart';

import 'chat_doctor_page.dart';

class DoctorListPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const DoctorListPage({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  late DatabaseReference doctorRef;
  List<Map> allDoctors = [];
  List<Map> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    doctorRef = FirebaseDatabase.instance.ref().child('catDoc/doctors/${widget.categoryId}');
    fetchDoctors();
  }

  void fetchDoctors() {
    doctorRef.once().then((DatabaseEvent event) {
      List<Map> doctorsList = [];
      if (event.snapshot.value != null) {
        Map data = event.snapshot.value as Map;
        data.forEach((key, value) {
          Map doctor = Map<String, dynamic>.from(value);
          doctor['key'] = key;
          doctorsList.add(doctor);
        });
      }
      setState(() {
        allDoctors = doctorsList;
        filteredDoctors = allDoctors;
      });
    });
  }

  void filterSearch(String query) {
    List<Map> filtered = allDoctors.where((doctor) {
      final name = doctor['dname']?.toString().toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredDoctors = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Doctors'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                labelText: 'Search by doctor name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredDoctors.isEmpty
                  ? const Center(child: Text('No doctors found.'))
                  : ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  return doctorCard(doctor: filteredDoctors[index]);
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
    );
  }

  Widget doctorCard({required Map doctor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetails(doctor: doctor),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: doctor['image'] != null && doctor['image'] != ""
                    ? Image.network(
                  doctor['image'],
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.person, size: 120, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                doctor['dname'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                doctor['specialization'] ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                doctor['hospital_name'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat, color: Colors.blueAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDoctorPage(doctor: doctor),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorDetails extends StatelessWidget {
  final Map doctor;

  const DoctorDetails({Key? key, required this.doctor}) : super(key: key);

  Future<void> _launchMaps(String query) async {
    String urlStr = query.startsWith("http")
        ? query
        : "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}";
    final Uri url = Uri.parse(urlStr);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor['dname'] ?? ''),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDoctorPage(doctor: doctor),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: doctor['image'] != null && doctor['image'] != ""
                        ? Image.network(
                      doctor['image'],
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.person, size: 150, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoText("Specialization: ${doctor['specialization'] ?? ''}", fontSize: 18, fontWeight: FontWeight.bold),
                  const SizedBox(height: 12),
                  _buildInfoText("Experience: ${doctor['years_of_experience'] ?? ''} years"),
                  const SizedBox(height: 12),
                  _buildInfoText("Hospital: ${doctor['hospital_name'] ?? ''}"),
                  const SizedBox(height: 12),
                  _buildInfoText("Address: ${doctor['hospital_address'] ?? ''}"),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: InkWell(
                      onTap: () => _launchMaps(doctor['hospital_location'] ?? ''),
                      child: Text(
                        "Location: ${doctor['hospital_location'] ?? ''}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blue[50],
    );
  }

  Widget _buildInfoText(String text, {double fontSize = 16, FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }
}
