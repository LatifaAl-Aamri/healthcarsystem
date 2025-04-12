import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcarsystem/local_notification.dart';

class AdminManageCategories extends StatefulWidget {
  const AdminManageCategories({Key? key}) : super(key: key);

  @override
  _AdminManageCategoriesState createState() => _AdminManageCategoriesState();
}

class _AdminManageCategoriesState extends State<AdminManageCategories> {
  final DatabaseReference _categoriesRef = FirebaseDatabase.instance.ref().child('catDoc/categories');

  TextEditingController _searchController = TextEditingController();
  List<MapEntry<dynamic, dynamic>> _allCategories = [];
  List<MapEntry<dynamic, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCategories);
    LocalNotification.startNoti();
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
      appBar: AppBar(
        title: const Text('Manage Categories'),
        backgroundColor: Colors.blueAccent,
      ),
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

                Map<dynamic, dynamic> categories = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                _allCategories = categories.entries.toList();

                if (_searchController.text.isEmpty) {
                  _filteredCategories = List.from(_allCategories);
                }

                return ListView(
                  children: _filteredCategories.map((entry) {
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
                            return const Icon(Icons.broken_image, color: Colors.red);
                          },
                        )
                            : Image.network(
                          imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, color: Colors.red);
                          },
                        )
                            : const Icon(Icons.image, color: Colors.grey),
                        title: Text(
                          categoryData['cname'] ?? 'Unknown Category',
                        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text("Add New Category", style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _addCategory() {
    final _formKey = GlobalKey<FormState>();
    TextEditingController categoryController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Category name is required.';
                    }
                    final namePattern = RegExp(r'^[A-Za-z ]+$');
                    if (!namePattern.hasMatch(value.trim())) {
                      return 'Only letters and spaces allowed.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image Path (URL only)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Image URL is required.';
                    }
                    if (!value.trim().startsWith('http')) {
                      return 'Must be a valid link starting with http or https.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // ✅ Check for duplicate category
                  final newName = categoryController.text.trim().toLowerCase();
                  final existingSnapshot = await _categoriesRef.get();

                  if (existingSnapshot.exists) {
                    final existing = Map<String, dynamic>.from(
                        existingSnapshot.value as Map);

                    final duplicate = existing.values.any((cat) {
                      final name = (cat['cname'] ?? '').toString().toLowerCase();
                      return name == newName;
                    });

                    if (duplicate) {
                      // Show error if duplicate
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("This category name already exists."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  // ✅ Add new category if no duplicate
                  await _categoriesRef.push().set({
                    'cname': categoryController.text.trim(),
                    'image': imageController.text.trim(),
                  });

                  // ✅ Show local notification
                  await LocalNotification.showNoti(
                    id: DateTime.now().millisecondsSinceEpoch % 100000,
                    title: "Healthcare Admin",
                    body: "You have successfully added a new category.",
                  );

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
    final _formKey = GlobalKey<FormState>();
    TextEditingController categoryController = TextEditingController(text: categoryData['cname'] ?? '');
    TextEditingController imageController = TextEditingController(text: categoryData['image'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Category name is required.';
                    }
                    final trimmed = value.trim();
                    if (trimmed.length < 3) {
                      return 'Category name must be at least 3 characters.';
                    }
                    final namePattern = RegExp(r'^[A-Za-z ]+$');
                    if (!namePattern.hasMatch(trimmed)) {
                      return 'Only letters and spaces allowed.';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image Path (URL only)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Image URL is required.';
                    }
                    if (!value.trim().startsWith('http')) {
                      return 'Must be a valid link starting with http or https.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _categoriesRef.child(categoryId).update({
                    'cname': categoryController.text.trim(),
                    'image': imageController.text.trim(),
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
          content: const Text('Are you sure you want to delete this category? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _categoriesRef.child(categoryId).remove();
                Navigator.pop(context);
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
