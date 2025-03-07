import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminSearchPage extends StatefulWidget {
  const AdminSearchPage({Key? key}) : super(key: key);

  @override
  _AdminSearchPageState createState() => _AdminSearchPageState();
}

class _AdminSearchPageState extends State<AdminSearchPage> {
  final DatabaseReference _categoriesRef =
  FirebaseDatabase.instance.ref().child('categories');

  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _categoriesRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text('No categories found.'));
                }

                Map<dynamic, dynamic> categories =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                return ListView(
                  children: categories.entries.map((entry) {
                    String categoryId = entry.key;
                    Map categoryData = entry.value;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: categoryData['image'] != null
                            ? Image.network(
                          categoryData['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image),
                        title: Text(categoryData['name']),
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
                              icon:
                              const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteCategory(categoryId);
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
            onPressed: () {
              _addCategory();
            },
            child: const Text("Add New Category"),
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    categoryController.clear();
    imageController.clear();

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
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _categoriesRef.push().set({
                    'name': categoryController.text,
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
    categoryController.text = categoryData['name'];
    imageController.text = categoryData['image'] ?? '';

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
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  _categoriesRef.child(categoryId).update({
                    'name': categoryController.text,
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

  void _deleteCategory(String categoryId) {
    _categoriesRef.child(categoryId).remove();
  }
}



//using storage in fireabase


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
//
// class AdminSearchPage extends StatefulWidget {
//   const AdminSearchPage({Key? key}) : super(key: key);
//
//   @override
//   _AdminSearchPageState createState() => _AdminSearchPageState();
// }
//
// class _AdminSearchPageState extends State<AdminSearchPage> {
//   final DatabaseReference _categoriesRef = FirebaseDatabase.instance.ref().child('categories');
//   final ImagePicker _picker = ImagePicker();
//   File? _selectedImage;
//   String? _imageURL;
//
//   TextEditingController categoryController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Manage Categories')),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: _categoriesRef.onValue,
//               builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                 if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//                   return const Center(child: Text('No categories found.'));
//                 }
//
//                 Map<dynamic, dynamic> categories = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//
//                 return ListView(
//                   children: categories.entries.map((entry) {
//                     String categoryId = entry.key;
//                     Map categoryData = entry.value;
//
//                     return Card(
//                       margin: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         leading: categoryData['image'] != null
//                             ? Image.network(
//                           categoryData['image'],
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         )
//                             : const Icon(Icons.image),
//                         title: Text(categoryData['name']),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () {
//                                 _editCategory(categoryId, categoryData);
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 _deleteCategory(categoryId);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _addCategory,
//             child: const Text("Add New Category"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _addCategory() {
//     categoryController.clear();
//     _selectedImage = null;
//     _imageURL = null;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add Category'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: categoryController,
//                 decoration: const InputDecoration(labelText: 'Category Name'),
//               ),
//               const SizedBox(height: 10),
//               _selectedImage != null
//                   ? Image.file(_selectedImage!, height: 100)
//                   : const Text("No image selected"),
//               ElevatedButton(
//                 onPressed: _pickImage,
//                 child: const Text("Choose Image"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//             ElevatedButton(
//               onPressed: () async {
//                 if (categoryController.text.isNotEmpty && _selectedImage != null) {
//                   String imageUrl = await _uploadImage(_selectedImage!);
//                   _categoriesRef.push().set({
//                     'name': categoryController.text,
//                     'image': imageUrl,
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _editCategory(String categoryId, Map categoryData) {
//     categoryController.text = categoryData['name'];
//     _imageURL = categoryData['image'] ?? '';
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Category'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: categoryController,
//                 decoration: const InputDecoration(labelText: 'Category Name'),
//               ),
//               const SizedBox(height: 10),
//               _imageURL != null
//                   ? Image.network(_imageURL!, height: 100)
//                   : const Text("No image selected"),
//               ElevatedButton(
//                 onPressed: _pickImage,
//                 child: const Text("Choose New Image"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//             ElevatedButton(
//               onPressed: () async {
//                 if (categoryController.text.isNotEmpty) {
//                   String imageUrl = _selectedImage != null ? await _uploadImage(_selectedImage!) : _imageURL!;
//                   _categoriesRef.child(categoryId).update({
//                     'name': categoryController.text,
//                     'image': imageUrl,
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _deleteCategory(String categoryId) {
//     _categoriesRef.child(categoryId).remove();
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<String> _uploadImage(File imageFile) async {
//     String fileName = 'categories/${DateTime.now().millisecondsSinceEpoch}.jpg';
//     Reference ref = FirebaseStorage.instance.ref().child(fileName);
//     UploadTask uploadTask = ref.putFile(imageFile);
//     TaskSnapshot snapshot = await uploadTask;
//     return await snapshot.ref.getDownloadURL();
//   }
// }
