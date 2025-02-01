// import 'package:flutter/material.dart';
//
// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({Key key}) : super(key: key);
//
//   @override
//   _ForgetPasswordState createState() => _ForgetPasswordState();
// }
//
// class _ForgetPasswordState extends State<ForgetPassword> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database package
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}
class _ForgetPasswordPageState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final DatabaseReference patientdb = FirebaseDatabase.instance.reference().child('Password'); // Reference to the database node for password reset requests
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Send Password Reset Email', style: TextStyle(color: Colors.brown)),
              onPressed: () async {
                // await FirebaseDatabase.instance.sendPasswordResetEmail(email:email.text);
                if (_emailController.text.isNotEmpty) {
                  await _resetPassword(_emailController.text);
                } else {
                  // Display error message if email is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your email')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _resetPassword(String email) async {
    try {
      String? resetKey = patientdb.push().key;
      // Store the password reset request in the database
      await patientdb.child(resetKey!).set({
        'email': email,
        'timestamp': ServerValue.timestamp, // Include the timestamp of the request
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent. Please check your email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}