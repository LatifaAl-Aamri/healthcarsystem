import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthcarsystem/patient_login_page.dart';
import 'package:healthcarsystem/reset_password_page.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController remail = TextEditingController();
  final DatabaseReference patientdb = FirebaseDatabase.instance.ref("Patient");

  Future<void> _sendOTPEmail(String email, String otp) async {
    final smtpServer =
    gmail("healthcaresystem24@gmail.com", "ojvc gnay kksc yrej");

    final message = Message()
      ..from = Address('healthcaresystem24@gmail.com', 'Latifa')
      ..recipients.add(email)
      ..subject = 'Password Reset'
      ..text = 'Your password reset code is: $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset code sent to your email.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send reset email: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _generateOTP() {
    final random = Random();
    // Generates a random 4-digit number
    int otp = 1000 + random.nextInt(9000);
    return otp.toString();
  }

  Future<void> _resetPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final email = remail.text.toLowerCase();

      // Check if the email exists in Firebase Database
      final snapshot =
      await patientdb.orderByChild('Email').equalTo(email).once();
      if (snapshot.snapshot.value != null) {
        // If email exists, generate OTP and send it via email
        Map<String, dynamic> userData =
        Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        String otp = _generateOTP();
        await _sendOTPEmail(email, otp);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: email, otp: otp,userID: userData.keys.first),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email does not exist.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password Page'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 40),
                  Container(
                    child: Image.asset(
                      'assets/images/forgot.png',
                      alignment: Alignment.center,
                      width: 100,
                      height: 250,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Enter Your Email to check if your Email exists",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: remail,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFE8EEF2),
                      hintStyle:
                      TextStyle(color: Color(0xFF003867), fontSize: 20),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 250,
            child: ElevatedButton(
              onPressed: () {
                _resetPassword(context); // Pass the context
              },
              child: const Text(
                "     Send    ",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1557B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(150, 40),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

