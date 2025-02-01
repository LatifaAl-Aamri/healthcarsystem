// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class Resetpage extends StatefulWidget {
//   const Resetpage({super.key});
//
//   @override
//   _ResetpageState createState() => _ResetpageState();
// }
//
// class _ResetpageState extends State<Resetpage> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController remail = TextEditingController();
//   DatabaseReference patientdb = FirebaseDatabase.instance.ref("Patient");
//
//   @override
//   void dispose() {
//     remail.dispose();
//     super.dispose();
//   }
//
//   Future<void> passwordReset() async {
//     try {
//       // Generate the password reset URL
//       var actionCodeSettings = ActionCodeSettings(
//         url: 'https://www.example.com/?email=${remail.text}&mode=resetPassword',
//         handleCodeInApp: true,
//         iOSBundleId: 'com.example.ios',
//         androidPackageName: 'com.example.android',
//         androidInstallApp: true,
//         androidMinimumVersion: '12',
//         dynamicLinkDomain: 'example.page.link',
//       );
//
//       // Send the password reset email with the URL
//       await FirebaseAuth.instance.sendPasswordResetEmail(
//         email: remail.text.trim(),
//         actionCodeSettings: actionCodeSettings,
//       );
//
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('Password reset link sent successfully!'),
//           );
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       print(e);
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text(e.message.toString()),
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reset Page'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 padding: const EdgeInsets.all(20),
//                 children: [
//                   SizedBox(height: 40),
//                   Container(
//                     child: Image.asset(
//                       'assets/images/forgot.png',
//                       alignment: Alignment.center,
//                       width: 100,
//                       height: 250,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: Text(
//                       "Enter Your Email and we will send you a password reset link",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//
//                   //Email
//                   TextFormField(
//                     controller: remail,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Email",
//                       labelStyle: TextStyle(fontSize: 20, color: Colors.black),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.black,
//                           width: 2.5,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.black,
//                           width: 2.5,
//                         ),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xFFE8EEF2),
//                       hintStyle: TextStyle(color: Color(0xFF003867), fontSize: 20),
//                       prefixIcon: Icon(
//                         Icons.email,
//                         color: Colors.black,
//                         size: 40,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your email ";
//                       } else if (!RegExp(
//                           r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
//                           .hasMatch(value)) {
//                         return "Please enter a valid email address";
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.center,
//             width: 200,
//             height: 250,
//             child: ElevatedButton(
//               onPressed: passwordReset,
//               child: const Text(
//                 "     Send    ",
//                 style: TextStyle(
//                   fontSize: 28,
//                   color: Colors.white,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: Color(0xFF1557B0), // Dark blue color
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 minimumSize: Size(150, 40), // Adjusted height and width
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }
