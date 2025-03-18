import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class AdminManageDoctors extends StatefulWidget {
  const AdminManageDoctors({Key? key}) : super(key: key);

  @override
  _AdminManageDoctorsState createState() => _AdminManageDoctorsState();
}

class _AdminManageDoctorsState extends State<AdminManageDoctors> {
  // Two database references—one for each partition
  final DatabaseReference eyeDoctorsRef =
  FirebaseDatabase.instance.ref("EyeDoctors");
  final DatabaseReference skinDoctorsRef =
  FirebaseDatabase.instance.ref("SkinDoctors");
  final DatabaseReference hairDoctorsRef =
  FirebaseDatabase.instance.ref("HairDoctors");
  final DatabaseReference respiratoryillnessesDoctorsRef =
  FirebaseDatabase.instance.ref("respiratoryillnessesDoctors");
  final DatabaseReference toothacheDoctorsRef =
  FirebaseDatabase.instance.ref("ToothacheDoctors");
  final DatabaseReference heartburnDoctorsRef =
  FirebaseDatabase.instance.ref("HeartburnDoctors");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8, // Two tabs: Eye and Skin doctors
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Doctors"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Hair Doctors"),
              Tab(text: "Skin Doctors"),
              Tab(text: "Eyes Doctors"),
              Tab(text: "Respiratory illnesses Doctors"),
              Tab(text: "Heartburn Doctors"),
              Tab(text: "Toothache Doctors"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DoctorListView(
              doctorRef: hairDoctorsRef,
              category: "HairDoctors",
            ),
            DoctorListView(
              doctorRef: skinDoctorsRef,
              category: "SkinDoctors",
            ),
            DoctorListView(
              doctorRef: eyeDoctorsRef,
              category: "EyeDoctors",
            ),
            DoctorListView(
              doctorRef: respiratoryillnessesDoctorsRef,
              category: "respiratoryillnessesDoctors",
            ),
            DoctorListView(
              doctorRef: toothacheDoctorsRef,
              category: "ToothacheDoctors",
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that lists doctors from a given Firebase reference and provides CRUD operations.
class DoctorListView extends StatefulWidget {
  final DatabaseReference doctorRef;
  final String category; // e.g. "EyeDoctors" or "SkinDoctors"
  const DoctorListView({Key? key, required this.doctorRef, required this.category})
      : super(key: key);

  @override
  _DoctorListViewState createState() => _DoctorListViewState();
}

class _DoctorListViewState extends State<DoctorListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // List of doctors
        Expanded(
          child: FirebaseAnimatedList(
            query: widget.doctorRef,
            defaultChild: const Center(child: CircularProgressIndicator()),
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map doctor = snapshot.value as Map;
              doctor['key'] = snapshot.key;
              return _buildDoctorCard(doctor);
            },
          ),
        ),
        // "Add Doctor" button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _showAddDoctorDialog,
            child: const Text("Add Doctor"),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(Map doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 8,
      child: ListTile(
        leading: doctor['image'] != null && doctor['image'] != ""
            ? Image.network(
          doctor['image'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.person, size: 50),
        title: Text(doctor['dname'] ?? "No Name"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Specialization: ${doctor['specialization'] ?? ""}"),
            Text("Experience: ${doctor['years_of_experience'] ?? ""} years"),
            Text("Hospital: ${doctor['hospital_name'] ?? ""}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showEditDoctorDialog(doctor);
              },
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(doctor['key']);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDoctorDialog() {
    // Controllers for each field.
    TextEditingController dnameController = TextEditingController();
    TextEditingController specializationController = TextEditingController();
    TextEditingController experienceController = TextEditingController();
    TextEditingController hospitalNameController = TextEditingController();
    TextEditingController hospitalAddressController = TextEditingController();
    TextEditingController hospitalLocationController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Doctor"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: dnameController,
                  decoration: const InputDecoration(labelText: "Doctor Name"),
                ),
                TextField(
                  controller: specializationController,
                  decoration: const InputDecoration(labelText: "Specialization"),
                ),
                TextField(
                  controller: experienceController,
                  decoration: const InputDecoration(labelText: "Years of Experience"),
                ),
                TextField(
                  controller: hospitalNameController,
                  decoration: const InputDecoration(labelText: "Hospital Name"),
                ),
                TextField(
                  controller: hospitalAddressController,
                  decoration: const InputDecoration(labelText: "Hospital Address"),
                ),
                TextField(
                  controller: hospitalLocationController,
                  decoration: const InputDecoration(labelText: "Hospital Location (URL)"),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (dnameController.text.isNotEmpty) {
                  widget.doctorRef.push().set({
                    "dname": dnameController.text,
                    "specialization": specializationController.text,
                    "years_of_experience": experienceController.text,
                    "hospital_name": hospitalNameController.text,
                    "hospital_address": hospitalAddressController.text,
                    "hospital_location": hospitalLocationController.text,
                    "image": imageController.text,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDoctorDialog(Map doctor) {
    // Pre-fill controllers with current values.
    TextEditingController dnameController = TextEditingController(text: doctor['dname']);
    TextEditingController specializationController = TextEditingController(text: doctor['specialization']);
    TextEditingController experienceController = TextEditingController(text: doctor['years_of_experience']);
    TextEditingController hospitalNameController = TextEditingController(text: doctor['hospital_name']);
    TextEditingController hospitalAddressController = TextEditingController(text: doctor['hospital_address']);
    TextEditingController hospitalLocationController = TextEditingController(text: doctor['hospital_location']);
    TextEditingController imageController = TextEditingController(text: doctor['image']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Doctor"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: dnameController,
                  decoration: const InputDecoration(labelText: "Doctor Name"),
                ),
                TextField(
                  controller: specializationController,
                  decoration: const InputDecoration(labelText: "Specialization"),
                ),
                TextField(
                  controller: experienceController,
                  decoration: const InputDecoration(labelText: "Years of Experience"),
                ),
                TextField(
                  controller: hospitalNameController,
                  decoration: const InputDecoration(labelText: "Hospital Name"),
                ),
                TextField(
                  controller: hospitalAddressController,
                  decoration: const InputDecoration(labelText: "Hospital Address"),
                ),
                TextField(
                  controller: hospitalLocationController,
                  decoration: const InputDecoration(labelText: "Hospital Location (URL)"),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.doctorRef.child(doctor['key']).update({
                  "dname": dnameController.text,
                  "specialization": specializationController.text,
                  "years_of_experience": experienceController.text,
                  "hospital_name": hospitalNameController.text,
                  "hospital_address": hospitalAddressController.text,
                  "hospital_location": hospitalLocationController.text,
                  "image": imageController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String doctorKey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this doctor?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                widget.doctorRef.child(doctorKey).remove();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
