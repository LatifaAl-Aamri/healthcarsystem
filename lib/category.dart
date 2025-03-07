import 'package:flutter/material.dart';
import 'package:healthcarsystem/advice_type.dart';
import 'package:healthcarsystem/eye_doctor_list.dart';

class Category extends StatefulWidget {
  final String userKey;

  const Category({super.key, required this.userKey});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10), // Adds space at the top
      child: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          _buildCategoryCard('Hair', 'assets/images/Hair.png', AdviceType()),
          _buildCategoryCard('Skin', 'assets/images/Skin.png', null),
          _buildCategoryCard('Eyes', 'assets/images/Eyes.png', EyeDoctorList()),
          _buildCategoryCard('Respiratory illnesses', 'assets/images/Respiratoryillnesses.png', null),
          _buildCategoryCard('Toothache', 'assets/images/Toothache.png', null),
          _buildCategoryCard('Heartburn', 'assets/images/Heartburn.png', null),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath, Widget? page) {
    return Card(
      color: Colors.grey[200],
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(imagePath, height: 130),
            Text(title, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
