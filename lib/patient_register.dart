import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcarsystem/patient_login_page.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState() {
    super.initState();
    initNotification();
  }

  Future<void> initNotification() async {
    await LocalNotification.startNoti();
    await requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

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
            buildTextField("User name", Icons.person, rname, false, (value) {
              if (value == null || value.isEmpty) return "Please enter your username";
              return null;
            }),
            const SizedBox(height: 20),
            buildPasswordField("Password", rpass, _isPasswordVisible, () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            }, (value) {
              if (value == null || value.isEmpty) return "Please enter your password";
              if (value.length < 7 || !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).*$').hasMatch(value)) {
                return 'Password must be at least 7 characters and include letters and numbers';
              }
              if (RegExp(r'\s').hasMatch(value)) return 'Password cannot contain spaces';
              return null;
            }),
            const SizedBox(height: 20),
            buildPasswordField("Confirm password", cpass, _isConfirmPasswordVisible, () {
              setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
            }, (value) {
              if (value == null || value.isEmpty) return "Please confirm your password";
              if (value != rpass.text) return 'Passwords do not match';
              return null;
            }),
            const SizedBox(height: 20),
            buildTextField("Email", Icons.email, remail, false, (value) {
              if (value == null || value.isEmpty) return "Please enter your email";
              if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                return "Please enter a valid email address";
              }
              return null;
            }, inputType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            buildTextField("Phone Number", Icons.phone, rnumber, false, (value) {
              if (value == null || value.isEmpty) return "Please enter your phone number";
              if (!RegExp(r'^[97][0-9]{7}$').hasMatch(value)) {
                return "Please enter a valid phone number";
              }
              return null;
            }, inputType: TextInputType.phone),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  bool userExists = await existUsername(rname.text);
                  bool emailExists = await existEmail(remail.text);
                  bool phoneExists = await existPhone(rnumber.text);

                  if (userExists || emailExists || phoneExists) {
                    String message = userExists
                        ? "The username you entered is already taken."
                        : emailExists
                        ? "The email address is already in use."
                        : "The phone number is already in use.";
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Duplicate Entry"),
                        content: Text(message),
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
                    await patientdb.child(key).set(newPatient.toJson());

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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1557B0),
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

  Widget buildTextField(String label, IconData icon, TextEditingController controller, bool obscure, String? Function(String?) validator,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      style: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
        filled: true,
        fillColor: const Color(0xFFE8EEF2),
        prefixIcon: Icon(icon, color: Colors.black, size: 40),
      ),
      validator: validator,
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller, bool visible, VoidCallback toggleVisibility,
      String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      style: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
        filled: true,
        fillColor: const Color(0xFFE8EEF2),
        prefixIcon: const Icon(Icons.lock, color: Colors.black, size: 40),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
      validator: validator,
    );
  }
}
