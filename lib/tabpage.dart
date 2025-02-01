// import 'package:flutter/material.dart';
// import 'package:healthcarsystem/splashpage.dart';
// import 'package:healthcarsystem/category.dart';
//
// class Tabpage extends StatefulWidget {
//   const Tabpage({super.key});
//
//   @override
//   _TabpageState createState() => _TabpageState();
// }
//
// class _TabpageState extends State<Tabpage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Subna Application'),
//           backgroundColor: Colors.red,
//         ),
//         drawer: Drawer(
//           backgroundColor: Colors.orange[50],
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/logo.png',
//                       alignment: Alignment.center,
//                       width: 200,
//                       height: 125,
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//               Divider(
//                 color: Colors.red,
//                 thickness: 5,
//                 height: 10,
//               ),
//               ListTile(
//                 leading: Icon(Icons.info),
//                 title: Text('About Us'),
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('About Us'),
//                         content: Text(
//                           'The online healthcare system is designed to bridge the gap between patients'
//                               'and healthcare providers by offering quick medical consultations and access to home remedies.'
//                           'This system provides flexibility, reduces prices, and minimizes wait times for medical care.'
//                             'By simplifying appointment booking and treatment processes,'
//                               'it aims to provide timely access to healthcare services while educating users on medical topics.',
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             style: TextButton.styleFrom(
//                               primary: Colors.red, // set text color to red
//                             ),
//                             child: Text('Close'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.contact_mail),
//                 title: Text('Contact Us'),
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Contact Information'),
//                         content: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text('Email: subnaApp@gmail.com'),
//                             SizedBox(height: 8),
//                             Text('Phone Number: 99133457'),
//                           ],
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             style: TextButton.styleFrom(
//                               primary: Colors.red, // set text color to red
//                             ),
//                             child: Text('Close'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.category),
//                 title: Text('Categories'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => Category()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.exit_to_app),
//                 title: Text('Logout'),
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => SplashPage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
