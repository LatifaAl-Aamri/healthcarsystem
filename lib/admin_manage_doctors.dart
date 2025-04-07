import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminManageDoctors extends StatefulWidget {
  const AdminManageDoctors({Key? key}) : super(key: key);

  @override
  _AdminManageDoctorsState createState() => _AdminManageDoctorsState();
}

class _AdminManageDoctorsState extends State<AdminManageDoctors> {
  final DatabaseReference _categoriesRef =
  FirebaseDatabase.instance.ref("catDoc/categories");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Doctors")),
      body: StreamBuilder(
        stream: _categoriesRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No categories found."));
          }

          Map<dynamic, dynamic> categories =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<MapEntry> entries = categories.entries.toList();

          return DefaultTabController(
            length: entries.length,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  tabs: entries
                      .map((e) => Tab(text: e.value['cname'] ?? 'Unnamed'))
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: entries.map((entry) {
                      String categoryId = entry.key;
                      return DoctorListView(categoryId: categoryId);
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class DoctorListView extends StatefulWidget {
  final String categoryId;
  const DoctorListView({Key? key, required this.categoryId}) : super(key: key);

  @override
  _DoctorListViewState createState() => _DoctorListViewState();
}

class _DoctorListViewState extends State<DoctorListView> {
  late DatabaseReference doctorRef;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dname = TextEditingController();
  final TextEditingController specialization = TextEditingController();
  final TextEditingController experience = TextEditingController();
  final TextEditingController hospitalName = TextEditingController();
  final TextEditingController hospitalAddress = TextEditingController();
  final TextEditingController hospitalLocation = TextEditingController();
  final TextEditingController image = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map> allDoctors = [];
  List<Map> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    doctorRef =
        FirebaseDatabase.instance.ref("catDoc/doctors/${widget.categoryId}");
    _searchController.addListener(_filterDoctors);
    _fetchDoctors();
  }

  void _fetchDoctors() {
    doctorRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        allDoctors = data.entries.map((e) {
          final doctor = Map<String, dynamic>.from(e.value);
          doctor['key'] = e.key;
          return doctor;
        }).toList();
        _filterDoctors();
      } else {
        setState(() {
          allDoctors = [];
          filteredDoctors = [];
        });
      }
    });
  }

  void _filterDoctors() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredDoctors = List.from(allDoctors);
      } else {
        filteredDoctors = allDoctors.where((doc) {
          return (doc['dname']?.toLowerCase().contains(query)) ?? false;
        }).toList();
      }
    });
  }

  // Validation for Doctor Name: must start with "Dr." and at least 3 letters following
  bool isValidDoctorName(String name) {
    final trimmed = name.trim();
    return RegExp(r'^Dr\.[A-Za-z ]{3,}$', caseSensitive: false)
        .hasMatch(trimmed);
  }

  // Validation for fields like specialization, hospital name, and hospital address:
  // Trimmed input must be at least 3 characters and include at least one letter.
  bool isValidTextField(String text) {
    final trimmed = text.trim();
    if (trimmed.length < 3) return false;
    return RegExp(r'[A-Za-z]').hasMatch(trimmed);
  }

  // Validation for years of experience: must be 1 or 2 digits.
  bool isValidExperience(String text) {
    return RegExp(r'^[0-9]{1,2}$').hasMatch(text.trim());
  }

  // Validate URL: empty is allowed; otherwise must be a valid URL with http/https.
  bool isValidURL(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return true;
    Uri? uri = Uri.tryParse(trimmed);
    return uri != null &&
        uri.isAbsolute &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void _submitDoctor(bool isEditing, [String? key]) {
    if (_formKey.currentState!.validate()) {
      final doctorData = {
        "dname": dname.text.trim(),
        "specialization": specialization.text.trim(),
        "years_of_experience": experience.text.trim(),
        "hospital_name": hospitalName.text.trim(),
        "hospital_address": hospitalAddress.text.trim(),
        "hospital_location": hospitalLocation.text.trim(),
        "image": image.text.trim(),
      };
      if (isEditing && key != null) {
        doctorRef.child(key).update(doctorData);
      } else {
        doctorRef.push().set(doctorData);
      }
      Navigator.pop(context);
    }
  }

  void _showDoctorDialog({bool isEditing = false, Map? doctor}) {
    if (isEditing && doctor != null) {
      dname.text = (doctor['dname'] ?? '').toString();
      specialization.text = (doctor['specialization'] ?? '').toString();
      experience.text = (doctor['years_of_experience'] ?? '').toString();
      hospitalName.text = (doctor['hospital_name'] ?? '').toString();
      hospitalAddress.text = (doctor['hospital_address'] ?? '').toString();
      hospitalLocation.text = (doctor['hospital_location'] ?? '').toString();
      image.text = (doctor['image'] ?? '').toString();
    } else {
      dname.clear();
      specialization.clear();
      experience.clear();
      hospitalName.clear();
      hospitalAddress.clear();
      hospitalLocation.clear();
      image.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit Doctor" : "Add Doctor"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Doctor Name Field
                TextFormField(
                  controller: dname,
                  decoration:
                  const InputDecoration(labelText: "Doctor Name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Doctor name is required.';
                    if (!value.contains('Dr.'))
                      return 'Doctor name must include "Dr."';
                    if (!isValidDoctorName(value))
                      return 'Ensure the name starts with "Dr." and has at least 3 letters after.';
                    return null;
                  },
                ),
                // Specialization Field
                TextFormField(
                  controller: specialization,
                  decoration:
                  const InputDecoration(labelText: "Specialization"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Specialization is required.';
                    if (!isValidTextField(value))
                      return 'Specialization must be at least 3 characters and include letters.';
                    return null;
                  },
                ),
                // Experience Field (1 or 2 digits)
                TextFormField(
                  controller: experience,
                  decoration: const InputDecoration(
                      labelText: "Years of Experience"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Experience is required.';
                    if (!isValidExperience(value))
                      return 'Experience must be a number with at most 2 digits.';
                    return null;
                  },
                ),
                // Hospital Name Field
                TextFormField(
                  controller: hospitalName,
                  decoration:
                  const InputDecoration(labelText: "Hospital Name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Hospital name is required.';
                    if (!isValidTextField(value))
                      return 'Hospital name must be at least 3 characters and include letters.';
                    return null;
                  },
                ),
                // Hospital Address Field
                TextFormField(
                  controller: hospitalAddress,
                  decoration:
                  const InputDecoration(labelText: "Hospital Address"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Hospital address is required.';
                    if (!isValidTextField(value))
                      return 'Hospital address must be at least 3 characters and include letters.';
                    return null;
                  },
                ),
                // Hospital Location Field (Optional)
                TextFormField(
                  controller: hospitalLocation,
                  decoration: const InputDecoration(
                      labelText: "Hospital Location (Optional)"),
                  // Allow empty input; if provided, must start with http/https.
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (!value.trim().startsWith('http')) {
                      return 'Must be a valid link starting with http or https.';
                    }
                    return null;
                  },
                ),
                // Image URL Field (Optional)
                TextFormField(
                  controller: image,
                  decoration: const InputDecoration(
                      labelText: "Image URL (Optional)"),
                  // Allow empty input; if provided, must start with http/https.
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (!value.trim().startsWith('http')) {
                      return 'Must be a valid link starting with http or https.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => _submitDoctor(isEditing, doctor?['key']),
            child: Text(isEditing ? "Update" : "Add"),
          )
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Map doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 8,
      child: ListTile(
        leading: doctor['image'] != null && doctor['image'] != ""
            ? Image.network(doctor['image'],
            width: 50, height: 50, fit: BoxFit.cover)
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
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () =>
                  _showDoctorDialog(isEditing: true, doctor: doctor),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmationDialog(doctor['key']),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this doctor?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              doctorRef.child(key).remove();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Doctor by Name',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Expanded(
          child: filteredDoctors.isEmpty
              ? const Center(child: Text("No doctors found."))
              : ListView.builder(
            itemCount: filteredDoctors.length,
            itemBuilder: (context, index) {
              return _buildDoctorCard(filteredDoctors[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => _showDoctorDialog(),
            child: const Text("Add Doctor"),
          ),
        )
      ],
    );
  }
}
