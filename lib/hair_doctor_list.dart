// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:healthcarsystem/chat_page.dart';
//
// class HairDoctorList extends StatefulWidget {
//   const HairDoctorList({Key? key}) : super(key: key);
//
//   @override
//   _HairDoctorListState createState() => _HairDoctorListState();
// }
//
// class _HairDoctorListState extends State<HairDoctorList> {
//   // Reference to the "HairDoctors" node in your Firebase database
//   DatabaseReference hairDoctorDb = FirebaseDatabase.instance.ref("HairDoctors");
//   Query hairDoctorQuery = FirebaseDatabase.instance.ref().child('HairDoctors');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hair Doctors List'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: FirebaseAnimatedList(
//           query: hairDoctorQuery,
//           defaultChild: const Center(child: CircularProgressIndicator()),
//           itemBuilder: (BuildContext context, DataSnapshot snapshot,
//               Animation<double> animation, int index) {
//             Map doctor = snapshot.value as Map;
//             doctor['key'] = snapshot.key;
//             return doctorCard(doctor: doctor);
//           },
//         ),
//       ),
//       backgroundColor: Colors.blue[50],
//     );
//   }
//
//   // Build a card for each hair doctor
//   Widget doctorCard({required Map doctor}) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       elevation: 8,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DoctorDetails(doctor: doctor),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Doctor image (or icon if no image)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: doctor['image'] != null && doctor['image'] != ""
//                     ? Image.network(
//                   doctor['image'],
//                   height: 120,
//                   width: 120,
//                   fit: BoxFit.cover,
//                 )
//                     : const Icon(Icons.person, size: 120, color: Colors.grey),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 doctor['dname'] ?? '',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 doctor['specialization'] ?? '',
//                 style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 doctor['hospital_name'] ?? '',
//                 style: const TextStyle(fontSize: 12, color: Colors.black54),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               // Chat icon button to navigate to ChatPage
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.chat, color: Colors.blueAccent),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatPage(doctor: doctor),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // The details page for each doctor
// class DoctorDetails extends StatelessWidget {
//   final Map doctor;
//
//   const DoctorDetails({Key? key, required this.doctor}) : super(key: key);
//
//   // Launch Google Maps using the hospital location URL
//   Future<void> _launchMaps(String query) async {
//     String urlStr;
//     if (query.startsWith("http")) {
//       urlStr = query;
//     } else {
//       urlStr =
//       "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}";
//     }
//     final Uri url = Uri.parse(urlStr);
//     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//       throw 'Could not open the map.';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(doctor['dname'] ?? ''),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           // Chat icon in the AppBar navigates to ChatPage
//           IconButton(
//             icon: const Icon(Icons.chat),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatPage(doctor: doctor),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         // Scrollable page in case content overflows
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Card(
//             elevation: 10,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Doctor image
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: doctor['image'] != null && doctor['image'] != ""
//                         ? Image.network(
//                       doctor['image'],
//                       height: 150,
//                       width: 150,
//                       fit: BoxFit.cover,
//                     )
//                         : const Icon(Icons.person, size: 150, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildInfoText(
//                     "Specialization: ${doctor['specialization'] ?? ''}",
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoText(
//                     "Experience: ${doctor['years_of_experience'] ?? ''} years",
//                     fontSize: 16,
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoText(
//                     "Hospital: ${doctor['hospital_name'] ?? ''}",
//                     fontSize: 16,
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoText(
//                     "Address: ${doctor['hospital_address'] ?? ''}",
//                     fontSize: 16,
//                   ),
//                   const SizedBox(height: 12),
//                   // Horizontally scrollable link for location
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: InkWell(
//                       onTap: () {
//                         _launchMaps(doctor['hospital_location'] ?? '');
//                       },
//                       child: Text(
//                         "Location: ${doctor['hospital_location'] ?? ''}",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.blue[50],
//     );
//   }
//
//   // Helper widget for displaying info text
//   Widget _buildInfoText(String text,
//       {double fontSize = 16, FontWeight fontWeight = FontWeight.normal}) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: fontSize,
//         fontWeight: fontWeight,
//         color: Colors.black87,
//       ),
//       textAlign: TextAlign.center,
//     );
//   }
// }
