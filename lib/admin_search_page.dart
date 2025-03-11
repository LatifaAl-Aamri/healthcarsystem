import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'local_notification.dart';

class AdminSearchPage extends StatefulWidget {
  const AdminSearchPage({Key? key}) : super(key: key);

  @override
  _AdminSearchPageState createState() => _AdminSearchPageState();
}

class _AdminSearchPageState extends State<AdminSearchPage> {
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
    if (_allCategories.isEmpty) return;

    setState(() {
      if (query.isEmpty) {
        _filteredCategories = List.from(_allCategories);
      } else {
        _filteredCategories = _allCategories.where((entry) {
          String title = entry.value['cname']?.toLowerCase() ?? '';
          return title.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Category',
                prefixIcon: const Icon(Icons.search),
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
                  return const Center(child: Text('No categories found.'));
                }

                Map<dynamic, dynamic> categories =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                _allCategories = categories.entries.toList();

                if (_searchController.text.isEmpty) {
                  _filteredCategories = List.from(_allCategories);
                }

                return ListView(
                  children: _filteredCategories.map((entry)  {
                    String categoryId = entry.key;
                    Map categoryData = entry.value;
                    String imagePath = categoryData['image'] ?? '';
                    bool isAssetImage = imagePath.startsWith("assets/");

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: imagePath.isNotEmpty
                            ? isAssetImage
                            ? Image.asset(
                          imagePath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                color: Colors.red);
                          },
                        )
                            : Image.network(
                          imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                color: Colors.red);
                          },
                        )
                            : const Icon(Icons.image, color: Colors.grey),
                        title: Text(categoryData['cname'] ?? 'Unknown Category'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _editCategory(categoryId, categoryData);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(categoryId);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addCategory,
            child: const Text("Add New Category"),
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    TextEditingController categoryController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: imageController,
                decoration:
                const InputDecoration(labelText: 'Image Path (URL or Asset)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _categoriesRef.push().set({
                    'cname': categoryController.text,
                    'image': imageController.text.isNotEmpty
                        ? imageController.text
                        : null,
                  });
                  Navigator.pop(context);


                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editCategory(String categoryId, Map categoryData) {
    TextEditingController categoryController =
    TextEditingController(text: categoryData['cname'] ?? '');
    TextEditingController imageController =
    TextEditingController(text: categoryData['image'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: imageController,
                decoration:
                const InputDecoration(labelText: 'Image Path (URL or Asset)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _categoriesRef.child(categoryId).update({
                    'cname': categoryController.text,
                    'image': imageController.text.isNotEmpty
                        ? imageController.text
                        : null,
                  });
                  Navigator.pop(context);
                }

              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete this category? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _categoriesRef.child(categoryId).remove(); // Delete the category
                Navigator.pop(context); // Close the dialog
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
