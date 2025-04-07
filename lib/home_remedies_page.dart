// import 'package:flutter/material.dart';
//
// class HomeRemediesPage extends StatefulWidget {
//   const HomeRemediesPage({Key? key}) : super(key: key);
//
//   @override
//   _HomeRemediesPageState createState() => _HomeRemediesPageState();
// }
//
// class _HomeRemediesPageState extends State<HomeRemediesPage> {
//   final List<Map<String, String>> remedies = [
//     {'title': 'Hair', 'image': 'assets/images/Hair.png'},
//     {'title': 'Skin', 'image': 'assets/images/Skin.png'},
//     {'title': 'Toothache', 'image': 'assets/images/Toothache.png'},
//     {'title': 'Heartburn', 'image': 'assets/images/Heartburn.png'},
//     {'title': 'Eyes', 'image': 'assets/images/Eyes.png'},
//     {'title': 'Respiratory illnesses', 'image': 'assets/images/Respiratory_illnesses.png'},
//   ];
//
//   final List<Map<String, String>> hairProblems = [
//     {'title': 'Dandruff Hair', 'image': 'assets/images/dandruff.png'},
//     {'title': 'Dry Hair', 'image': 'assets/images/dry_hair.png'},
//     {'title': 'Hair loss', 'image': 'assets/images/hair_loss.png'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Let's find home remedies",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Search home remedies category",
//                 prefixIcon: Icon(Icons.search),
//                 suffixIcon: Icon(Icons.mic),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               height: 120,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: remedies.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     width: 110,
//                     margin: EdgeInsets.symmetric(horizontal: 2),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: Image.asset(
//                             remedies[index]['image']!,
//                             height: 60,
//                             width: 60,
//                             fit: BoxFit.contain,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Icon(Icons.broken_image, size: 60, color: Colors.grey);
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(remedies[index]['title']!, textAlign: TextAlign.center),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 30),
//             Text(
//               "Top Hair Problems",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: hairProblems.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 10),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   child: ListTile(
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: Image.asset(
//                         hairProblems[index]['image']!,
//                         height: 80,
//                         width: 80,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Icon(Icons.broken_image, size: 80, color: Colors.grey);
//                         },
//                       ),
//                     ),
//                     title: Text(hairProblems[index]['title']!),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       // Add navigation logic
//                     },
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Add your appointment booking logic here
//               },
//               child: Text('Select home remedies'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
