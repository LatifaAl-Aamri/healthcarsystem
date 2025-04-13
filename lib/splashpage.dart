import 'package:flutter/material.dart';
import 'package:healthcarsystem/homepage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // title: Text('Online Healthcare System'),
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              child: Text(
                'Online Healthcare System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0D47A1),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Empowering patients with medical advice and natural remedies.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2BFBF),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                //primary: Color(0xFFF2BFBF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            // SizedBox(height: 5), // Add SizedBox for spacing
            Container(
              //width: 300, // Set width to match image width
              //height: 359.4, // Set height to match image height
              width: 700, // Set width to match image width
              height: 290, // Set height to match image height
              child: Image.asset(
                //'assets/images/splashlogo.png',
                'assets/images/logo.png',
                fit: BoxFit.contain, // Maintain aspect ratio and fit the image inside the container
              ),
            ),
          ],
        ),
      ),
      //backgroundColor: Colors.blue[50],
    );
  }
}
























// import 'package:flutter/material.dart';
// import 'package:healthcarsystem/homepage.dart';
//
// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);
//
//   @override
//   _SplashPageState createState() => _SplashPageState();
// }
//
// class _SplashPageState extends State<SplashPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Navigate to Homepage after a delay
//     Future.delayed(Duration(seconds: 10), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Homepage()),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Online Healthcare System'),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.only(top: 150),
//               alignment: Alignment.center,
//               child: Text(
//                 'Online Healthcare System',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color(0xFF0D47A1),
//                   fontSize: 35,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Empowering patients with medical advice and natural remedies.',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 700,
//               height: 355,
//               child: Image.asset(
//                 'assets/images/logo.png',
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
