// import 'package:flutter/material.dart';
// import 'package:biometric_storage/biometric_storage.dart';
// import 'menu_drawer_page.dart';
//
// class BiometricStorageAuthPage extends StatefulWidget {
//   const BiometricStorageAuthPage({Key? key}) : super(key: key);
//
//   @override
//   State<BiometricStorageAuthPage> createState() =>
//       _BiometricStorageAuthPageState();
// }
//
// class _BiometricStorageAuthPageState extends State<BiometricStorageAuthPage> {
//   String _status = "Waiting for authentication...";
//
//   Future<void> _authenticateUser() async {
//     final canAuth = await BiometricStorage().canAuthenticate();
//
//     if (canAuth != CanAuthenticateResponse.success) {
//       setState(() {
//         _status = "Biometric not available or not enrolled.";
//       });
//       return;
//     }
//
//     try {
//       final store = await BiometricStorage().getStorage(
//         'secure_login_token',
//         options: StorageFileInitOptions(authenticationRequired: true),
//       );
//
//       await store.write('LoggedIn');
//       final value = await store.read();
//
//       if (value == 'LoggedIn') {
//         setState(() => _status = 'Authentication successful');
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const MenuDrawerPage()),
//         );
//       } else {
//         setState(() => _status = 'Authentication failed');
//       }
//     } catch (e) {
//       setState(() => _status = 'Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Biometric Login")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(_status, style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _authenticateUser,
//                 icon: const Icon(Icons.fingerprint),
//                 label: const Text("Login with Fingerprint"),
//                 style: ElevatedButton.styleFrom(
//                   primary: const Color(0xFF1557B0),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10, horizontal: 20),
//                   textStyle: const TextStyle(fontSize: 22),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
