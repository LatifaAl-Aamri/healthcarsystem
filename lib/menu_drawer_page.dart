import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthcarsystem/change_password_page.dart';
import 'package:healthcarsystem/splashpage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category.dart';
import 'home_remedies_page.dart';

class MenuDrawerPage extends StatefulWidget {
  const MenuDrawerPage({super.key});

  @override
  _MenuDrawerPageState createState() => _MenuDrawerPageState();
}

class _MenuDrawerPageState extends State<MenuDrawerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference feedbackRef = FirebaseDatabase.instance.ref().child('feedback');
  double _overallRating = 0.0;
  TextEditingController _opinionController = TextEditingController();

  void saveFeedback() {
    String feedbackId = feedbackRef.push().key!;
    feedbackRef.child(feedbackId).set({
      'overallRating': _overallRating,
      'overallOpinion': _opinionController.text,
      'timestamp': ServerValue.timestamp,
    }).then((_) {
      setState(() {
        _overallRating = 0.0;
        _opinionController.clear();
      });
    }).catchError((error) {
      print('Error submitting feedback: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Online Healthcare System'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Consult Doctors'),
              Tab(text: 'Home Remedies'),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        body: const TabBarView(
          children: [
            Category(userKey: ''),
            HomeRemediesPage(),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.blueGrey[100],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      alignment: Alignment.center,
                      width: 200,
                      height: 125,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 2, height: 10),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Us'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('About Us'),
                        content: const Text(
                          'The online healthcare system is designed to bridge the gap between patients '
                              'and healthcare providers by offering quick medical consultations and access '
                              'to home remedies. This system provides flexibility, reduces prices, and minimizes '
                              'wait times for medical care. By simplifying appointment booking and treatment processes, '
                              'it aims to provide timely access to healthcare services while educating users on medical topics.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text('Contact Us'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Contact Information'),
                        content: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Email: OnlineHealthcareSystem@gmail.com'),
                            SizedBox(height: 8),
                            Text('Phone Number: 99123578'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.red, // set text color to red
                            ),
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.password_outlined),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
                  );
                },
              ),
              ////////////////////////////////////////////////////////////////
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Provide Feedback and Suggestions'),
                        content: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'Your Overall Opinion:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _opinionController,
                                  maxLines: 4,
                                  textInputAction: TextInputAction.done,
                                  validator: (String? text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Feedback is required!';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter your overall opinion here...',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Rate our app:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                RatingBar.builder(
                                  initialRating: _overallRating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _overallRating = rating;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate() && _overallRating > 0) {
                                      saveFeedback(); // Save feedback only if both fields are filled
                                      Navigator.of(context).pop(); // Close dialog after submitting
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please provide both a rating and feedback!'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Submit Feedback'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ////////////////////////////////////////////////////////////////

              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () async {
                  // Clear stored user session data
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('userKey'); // Remove only the userKey

                  // Navigate back to SplashPage to restart session
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SplashPage()),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
