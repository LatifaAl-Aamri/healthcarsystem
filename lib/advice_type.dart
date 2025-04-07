// import 'package:flutter/material.dart';
//
// import 'consult_doctor_page.dart';
// import 'home_remedies_page.dart';
//
// class AdviceType extends StatefulWidget {
//   const AdviceType({super.key});
//
//   @override
//   _AdviceTypeState createState() => _AdviceTypeState();
// }
//
// class _AdviceTypeState extends State<AdviceType> {
//   int _selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Advice Type'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(height: 40),
//           Text(
//             'Select the type of advice you want',
//             style: TextStyle(fontSize: 20),
//           ),
//           SizedBox(height: 40),
//           Card(
//             color: Colors.grey[200],
//             child: InkWell(
//               splashColor: Colors.blue.withAlpha(30),
//               onTap: () {
//                 // Handle tap
//               },
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Image.asset('assets/images/Hair.png', height: 150),
//                   Text('Hair', style: TextStyle(fontSize: 20)),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 40),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Card(
//                 color: Colors.grey[200],
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset('assets/images/HomeRemedies.png', height: 100),
//                       SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => HomeRemediesPage()),
//                           );
//                           setState(() {
//                             _selectedIndex = 0;
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: _selectedIndex == 0 ? Colors.blue : Colors.grey,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                         ),
//                         child: Text('Home remedies'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 20),
//               Card(
//                 color: Colors.grey[200],
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset('assets/images/ConsultDoctor.png', height: 100),
//                       SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => ConsultDoctorPage()),
//                           );
//                           setState(() {
//                             _selectedIndex = 1;
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: _selectedIndex == 1 ? Colors.blue : Colors.grey,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                         ),
//                         child: Text('Consult a doctor'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
