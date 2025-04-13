// doctor_login_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'doctor_home_page.dart';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({Key? key}) : super(key: key);

  @override
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  DatabaseReference doctordb = FirebaseDatabase.instance.ref("Doctor");
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Login"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Doctor Username"),
                validator: (val) => val!.isEmpty ? "Enter username" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                validator: (val) => val!.isEmpty ? "Enter password" : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    doctordb.once().then((event) {
                      bool matched = false;
                      String doctorKey = "", doctorUsername = "";
                      Map data = event.snapshot.value as Map;

                      data.forEach((key, value) {
                        if (value['UserName'] == usernameController.text.trim() &&
                            value['Password'] == passwordController.text.trim()) {
                          matched = true;
                          doctorKey = key;
                          doctorUsername = value['UserName'];
                        }
                      });

                      if (matched) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorHomePage(
                              doctorKey: doctorKey,
                              doctorUsername: doctorUsername,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid credentials")),
                        );
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
