import 'package:flutter/material.dart';
import 'package:healthcarsystem/advice_type.dart';
import 'package:healthcarsystem/splashpage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthcarsystem/advice_type.dart';

import 'change_password_page.dart';
import 'eye_doctor_list.dart';

class Category extends StatefulWidget {
  String userKey = "";

  Category({super.key, required userKey});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference feedbackRef =
  FirebaseDatabase.instance.ref().child('feedback');
  double _overallRating = 0.0;
  TextEditingController _opinionController = TextEditingController();

  get globalUserKey => null;

  void saveFeedback() {
    String feedbackId = feedbackRef.push().key!;
    feedbackRef.child(feedbackId).set({
      'overallRating': _overallRating,
      'overallOpinion': _opinionController.text,
      'timestamp': ServerValue.timestamp,
    }).then((_) {
      print('Feedback submitted successfully');
      // Clear fields after submission if needed
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
    print(widget.userKey);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Online Healthcare System'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        // backgroundColor: Color(0xFF6C3D7),
        backgroundColor: Colors.blueGrey[100],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(),
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
                  SizedBox(height: 10),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('About Us'),
                      content: Text(
                        'The online healthcare system is designed to bridge the gap between patients'
                            ' and healthcare providers by offering quick medical consultations and access '
                            'to home remedies. This system provides flexibility, reduces prices, and minimizes '
                            'wait times for medical care. By simplifying appointment booking and treatment processes,'
                            ' it aims to provide timely access to healthcare services while educating users on medical topics.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
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
            //////////////////////////////////////////////////////////////////////////////////////////////////////
            ListTile(
              leading: Icon(Icons.password_outlined),
              title: Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangePasswordPage(),
                  ),
                );
              },
            ),
            ////////////////////////////////////////////////////////////////////////////////////////////////////////
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Contact Information'),
                      content: Column(
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
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Provide feedback and suggestions'),
                      content: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.handshake,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Your overall opinion:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _opinionController,
                                maxLines: 4,
                                textInputAction: TextInputAction.done,
                                validator: (String? text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText:
                                  'Enter your overall opinion here...',
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Rate our app:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 25),
                              RatingBar.builder(
                                initialRating: _overallRating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30,
                                itemPadding:
                                EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _overallRating = rating;
                                  });
                                },
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Validate the form before submitting
                                  if (_formKey.currentState!.validate()) {
                                    // Handle the feedback submission
                                    print('Overall Rating: $_overallRating');
                                    print(
                                        'Overall Opinion: ${_opinionController.text}');
                                    saveFeedback();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .blueGrey, // Set the background color to red
                                ),
                                child: Text('Submit Feedback'),
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
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            color: Colors.grey[200],
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdviceType()),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/images/Hair.png', height: 130),
                  Text('Hair', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[200],
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/images/Skin.png', height: 130),
                  Text('Skin', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[200],
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigate to Eyes category page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EyeDoctorList()),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/images/Eyes.png', height: 100),
                  Text('Eyes', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[200],
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigate to Respiratory illnesses category page
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/images/Respiratoryillnesses.png',
                      height: 150),
                  Text('Respiratory illnesses', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[200],
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigate to Toothache category page
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/images/Toothache.png', height: 150),
                  Text('Toothache', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[200],
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigate to Heartburn category page
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/images/Heartburn.png', height: 150),
                  Text('Heartburn', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
