import 'package:flutter/material.dart';
import 'package:healthcarsystem/patient_login_page.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String otp;
  final String userID;

  const ResetPasswordPage({
    Key? key,
    required this.email,
    required this.otp,
    required this.userID,
  }) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final DatabaseReference patientdb = FirebaseDatabase.instance.ref("Patient");
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'An OTP has been sent to your Email',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Email:${widget.email}',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: otpController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password.';
                      } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$').hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and length should be greater than 6.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (otpController.text == widget.otp) {
                          resetPassword(newPasswordController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid OTP.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Reset Password'),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  // Function to hash the password
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> resetPassword(String newPassword) async {
    try {
      await patientdb.child(widget.userID).update({'Password': hashPassword(newPassword)});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      //Navigate to login page after resetting the password
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientLogin()),
      );
    } catch (error) {
      print('Failed to reset password: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset password: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
