import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcarsystem/advice_type.dart';
import 'package:healthcarsystem/eye_doctor_list.dart';
import 'package:healthcarsystem/respiratory_illnesses_doctor_list.dart';
import 'package:healthcarsystem/skin_doctor_list.dart';
import 'package:healthcarsystem/toothache_doctor_list.dart';

import 'hair_doctor_list.dart';
import 'heartburn_doctor_list.dart';

class Category extends StatefulWidget {
  final String userKey;

  const Category({super.key, required this.userKey});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final DatabaseReference _categoriesRef =
  FirebaseDatabase.instance.ref().child('categories');

  TextEditingController _searchController = TextEditingController();
  List<MapEntry<dynamic, dynamic>> _allCategories = [];
  List<MapEntry<dynamic, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCategories);
  }

  void _filterCategories() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories.where((entry) {
        String title = entry.value['cname']?.toLowerCase() ?? '';
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Category',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _categoriesRef.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const Center(child: Text('No categories available.'));
              }

              Map<dynamic, dynamic> categories =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

              // Convert Map to List and sort: Assets first, then Network images
              _allCategories = categories.entries.toList()
                ..sort((a, b) {
                  bool isAAsset = a.value['image'] != null && !a.value['image'].startsWith("http");
                  bool isBAsset = b.value['image'] != null && !b.value['image'].startsWith("http");
                  return (isBAsset ? 1 : 0) - (isAAsset ? 1 : 0); // Assets first
                });

              if (_filteredCategories.isEmpty) {
                _filteredCategories = List.from(_allCategories);
              }

              return GridView.count(
                crossAxisCount: 2,
                children: _filteredCategories.map((entry) {
                  String title = entry.value['cname'] ?? 'Unknown';
                  String imagePath = entry.value['image'] ?? '';

                  return _buildCategoryCard(title, imagePath);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Card(
      color: Colors.grey[200],
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (title == "Hair") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HairDoctorList()));
          } else if (title == "Eyes") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EyeDoctorList()));
          }else if (title == "Skin") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SkinDoctorList()));
          }else if (title == "Toothache") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ToothacheDoctorList()));
          }else if (title == "Respiratory illnesses") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RespiratoryIllnessesDoctorList()));
          } else if (title == "Heartburn") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HeartburnDoctorList()));
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getImageWidget(imagePath),
            Text(title, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _getImageWidget(String imagePath) {
    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        height: 130,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.red, size: 100);
        },
      );
    } else {
      return Image.asset(
        imagePath,
        height: 130,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image, color: Colors.grey, size: 100);
        },
      );
    }
  }
}





