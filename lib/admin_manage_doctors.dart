import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcarsystem/local_notification.dart';

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

  final Map<String, String> categorySpecializationMap = {
    'heart': 'Cardiology',
    'chronic pain': 'Pain Management',
    'hair': 'Hair Transplant',
    'skin': 'Dermatology',
    'teeth': 'Dental',
    'dermatology': 'Dermatology',
    'endocrine and diabetes diseases': 'Endocrinology & Diabetes',
    'ENT': 'ENT',
    'family medicine': 'Family Medicine',
    'digestive': 'Gastroenterology',
    'general surgery': 'General Surgery',
    'esoteric': 'Internal Medicine',
    'kidney and urinary tract': 'Nephrology & Urology',
    'feeding': 'Nutrition & Dietetics',
    'eyes': 'Ophthalmology',
    'orthopedic surgery': 'Orthopedic Surgery',
    'psychiatry': 'Psychiatry',
    'joints and natural medicine': 'Rheumatology & Physical Therapy',
    'heartburn': 'Gastroenterology',
    'respiratory illnesses': 'Pulmonology',
  };

  @override
  void initState() {
    super.initState();
    LocalNotification.startNoti();
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

  bool isValidDoctorName(String name) {
    final trimmed = name.trim();
    return RegExp(r'^Dr\.[A-Za-z ]{3,}$', caseSensitive: false)
        .hasMatch(trimmed);
  }

  bool isValidTextField(String text) {
    final trimmed = text.trim();
    if (trimmed.length < 3) return false;
    return RegExp(r'[A-Za-z]').hasMatch(trimmed);
  }

  bool isValidExperience(String text) {
    return RegExp(r'^[0-9]{1,2}$').hasMatch(text.trim());
  }

  bool isValidURL(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return true;
    Uri? uri = Uri.tryParse(trimmed);
    return uri != null &&
        uri.isAbsolute &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Future<void> _submitDoctor(bool isEditing, [String? key]) async {
    if (_formKey.currentState!.validate()) {
      String enteredSpecialization = specialization.text.trim().toLowerCase();
      String? expectedSpecialization;

      final categorySnapshot = await FirebaseDatabase.instance
          .ref("catDoc/categories/${widget.categoryId}")
          .get();

      if (categorySnapshot.exists) {
        final categoryName =
        categorySnapshot.child("cname").value.toString().toLowerCase();
        expectedSpecialization = categorySpecializationMap[categoryName];

        if (expectedSpecialization != null &&
            expectedSpecialization.toLowerCase() != enteredSpecialization) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Doctor specialization must match the category. Expected: $expectedSpecialization"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final doctorData = {
        "dname": dname.text.trim(),
        "specialization": specialization.text.trim(),
        "years_of_experience": experience.text.trim(),
        "hospital_name": hospitalName.text.trim(),
        "hospital_address": hospitalAddress.text.trim(),
        "hospital_location": hospitalLocation.text.trim(),
        "image": image.text.trim(),
      };

      bool isDuplicate = allDoctors.any((doc) {
        if (isEditing && doc['key'] == key) return false;
        return doc['dname'].toString().toLowerCase() ==
            doctorData['dname'].toString().toLowerCase() &&
            doc['years_of_experience'] == doctorData['years_of_experience'] &&
            doc['hospital_name'].toString().toLowerCase() ==
                doctorData['hospital_name'].toString().toLowerCase() &&
            doc['hospital_address'].toString().toLowerCase() ==
                doctorData['hospital_address'].toString().toLowerCase();
      });

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Doctor with the same details already exists."),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (isEditing && key != null) {
        await doctorRef.child(key).update(doctorData);
      } else {
        await doctorRef.push().set(doctorData);
        await LocalNotification.showNoti(
          id: DateTime.now().millisecondsSinceEpoch % 100000,
          title: "Healthcare Admin",
          body: "You have successfully added a new doctor.",
        );
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
                TextFormField(
                  controller: dname,
                  decoration: const InputDecoration(labelText: "Doctor Name"),
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
                TextFormField(
                  controller: specialization,
                  decoration: const InputDecoration(labelText: "Specialization"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Specialization is required.';
                    if (value.trim() == '0')
                      return 'Specialization cannot be zero.';
                    if (!isValidTextField(value))
                      return 'Specialization must be at least 3 characters and include letters.';
                    return null;
                  },
                ),
                TextFormField(
                  controller: experience,
                  decoration:
                  const InputDecoration(labelText: "Years of Experience"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Experience is required.';
                    if (!isValidExperience(value))
                      return 'Experience must be a number with at most 2 digits.';
                    if (value.trim() == '0')
                      return 'Experience cannot be zero.';
                    return null;
                  },
                ),
                TextFormField(
                  controller: hospitalName,
                  decoration: const InputDecoration(labelText: "Hospital Name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Hospital name is required.';
                    if (!isValidTextField(value))
                      return 'Hospital name must be at least 3 characters and include letters.';
                    return null;
                  },
                ),
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
                TextFormField(
                  controller: hospitalLocation,
                  decoration: const InputDecoration(
                      labelText: "Hospital Location (Optional)"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (!value.trim().startsWith('http')) {
                      return 'Must be a valid link starting with http or https.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: image,
                  decoration:
                  const InputDecoration(labelText: "Image URL (Optional)"),
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
              doctorRef.child(key).remove().then((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Doctor deleted successfully."),
                    backgroundColor: Colors.red,
                  ),
                );
              });
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
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
