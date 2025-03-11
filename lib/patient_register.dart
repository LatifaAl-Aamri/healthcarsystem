import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcarsystem/patient_login_page.dart';

import 'ModelClass.dart';
import 'local_notification.dart';

class PatientRegister extends StatefulWidget {
  const PatientRegister({Key? key}) : super(key: key);

  @override
  _PatientRegisterState createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController rname = TextEditingController();
  TextEditingController rpass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  TextEditingController remail = TextEditingController();
  TextEditingController rnumber = TextEditingController();
  DatabaseReference patientdb = FirebaseDatabase.instance.ref("Patient");

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> existUsername(String username) async {
    final snapshot = await patientdb.orderByChild('UserName').equalTo(username).once();
    return snapshot.snapshot.value != null;
  }

  Future<bool> existEmail(String email) async {
    final snapshot = await patientdb.orderByChild('Email').equalTo(email.toLowerCase()).once();
    return snapshot.snapshot.value != null;
  }

  Future<bool> existPhone(String phone) async {
    final snapshot = await patientdb.orderByChild('MobileNumber').equalTo(phone).once();
    return snapshot.snapshot.value != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Image.asset(
              'assets/images/register.png',
              alignment: Alignment.center,
              width: 70,
              height: 150,
            ),
            TextFormField(
              controller: rname,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "User name",
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
                hintStyle: TextStyle(color: Color(0xFF003867), fontSize: 20),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your username";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: rpass,
              obscureText: !_isPasswordVisible,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFE8EEF2),
                hintStyle: const TextStyle(color: Color(0xFF003867), fontSize: 20),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                  size: 40,
                ),
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
                  return "Please enter your password";
                }
                if (value.length < 7 || !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).*$').hasMatch(value)) {
                  return 'Password must be at least 7 characters and a combination of numbers and characters';
                }
                if (RegExp(r'\s').hasMatch(value)) {
                  return 'Password cannot contain spaces';
                }

                // if (value.length < 7 || !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).*$').hasMatch(value)) {
                //   return 'Password must be at least 7 characters and a combination of numbers and characters';
                // }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: cpass,
              obscureText: !_isConfirmPasswordVisible,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Confirm password",
                labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFE8EEF2),
                hintStyle: const TextStyle(color: Color(0xFF003867), fontSize: 20),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                  size: 40,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please confirm your password";
                }
                if (value != rpass.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: remail,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
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
                hintStyle: TextStyle(color: Color(0xFF003867), fontSize: 20),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                } else if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(value)) {
                  return "Please enter a valid email address";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: rnumber,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "Phone Number",
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
                hintStyle: TextStyle(color: Color(0xFF003867), fontSize: 20),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your phone number";
                }
                if (!RegExp(r'^[97][0-9]{7}$').hasMatch(value)) {
                  return "Please enter a valid phone number";
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  bool userExists = await existUsername(rname.text);
                  bool emailExists = await existEmail(remail.text);
                  bool phoneExists = await existPhone(rnumber.text);

                  if (userExists) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Username Taken"),
                        content: const Text("The username you entered is already taken. Please choose another one."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Change"),
                          ),
                        ],
                      ),
                    );
                  } else if (emailExists) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Email Taken"),
                        content: const Text("The email address you provided is already in use. Please enter a different email address."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Change"),
                          ),
                        ],
                      ),
                    );
                  } else if (phoneExists) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Phone Number Taken"),
                        content: const Text("The phone number you provided is already in use. Please enter a different phone number."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Change"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final hashedPassword = hashPassword(rpass.text);
                    Patient newPatient = Patient(
                      rname.text,
                      hashedPassword,
                      remail.text.toLowerCase(),
                      rnumber.text,
                    );
                    String key = patientdb.push().key.toString();
                    patientdb.child(key).set(newPatient.toJson());

                    // Initialize notification
                    await LocalNotification.startNoti();

                    // Show notification
                    await LocalNotification.showNoti(
                      id: 1,
                      title: "Healthcare System",
                      body: "Congratulations! Your account has been successfully created.",
                    );


                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PatientLogin(),
                      ),
                    );
                  }
                }

                //LocalNotification.startNoti();
                //LocalNotification.showNoti(id: 1, title: "Healthcare System notification", body: "Congratulations, your account has been successfully created.");
                //displayMyAlertDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF1557B0),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Register", style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

}
