import 'package:flutter/material.dart';
import 'admin_manage_categories.dart';
import 'admin_manage_doctors.dart';

class AdminSearchPage extends StatefulWidget {
  const AdminSearchPage({Key? key}) : super(key: key);

  @override
  _AdminSearchPageState createState() => _AdminSearchPageState();
}

class _AdminSearchPageState extends State<AdminSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to AdminManageCategories page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminManageCategories(),
                  ),
                );
              },
              child: const Text('Manage Categories'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to AdminManageDoctors page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  AdminManageDoctors(),
                  ),
                );
              },
              child: const Text('Manage Doctors'),
            ),
          ],
        ),
      ),
    );
  }
}
