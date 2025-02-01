import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthcarsystem/category.dart';
import 'package:healthcarsystem/patient_register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthcarsystem/forgot_password_page.dart';
import 'package:healthcarsystem/resetpage.dart';

import 'forget_password.dart';

class PatientLogin extends StatefulWidget {
  const PatientLogin({super.key});

  @override
  _PatientLoginState createState() => _PatientLoginState();
}

class _PatientLoginState extends State<PatientLogin> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController uname = TextEditingController();
  TextEditingController upass = TextEditingController();
  DatabaseReference patientdb = FirebaseDatabase.instance.ref("Patient");

  bool _isPasswordVisible = false;

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String> authenticateUser(String username, String password) async {
    final snapshot =
    await patientdb.orderByChild('UserName').equalTo(username).once();
    print(snapshot.snapshot.value);
    if (snapshot.snapshot.value != null) {
      Map<String, dynamic> userData =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      String storedPassword = userData.values.first['Password'];
      String uid = userData.keys.first;
      if (storedPassword == hashPassword(password))
        return uid;
      else
        return "";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/login.png',
                alignment: Alignment.center,
                width: 100,
                height: 250,
              ),
              TextFormField(
                controller: uname,
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
                controller: upass,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle:
                  const TextStyle(fontSize: 20, color: Colors.black),
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
                  hintStyle:
                  const TextStyle(color: Color(0xFF003867), fontSize: 20),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                    size: 40,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        //Resetpage
                        //ForgotPasswordPage
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      "Forgot Password!?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatientRegister()),
                  );
                },
                child: const Text("New",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF1557B0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Dark blue color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    String authenticated =
                    await authenticateUser(uname.text, upass.text);
                    if (authenticated.isNotEmpty) {
                      print(authenticated);
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      await prefs.setString('userKey', authenticated);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged In successfully.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Category(userKey: authenticated),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Login Failed"),
                          content: const Text(
                              "Incorrect username or password. Please try again or register as a new."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF1557B0), // Dark blue color
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Login",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
