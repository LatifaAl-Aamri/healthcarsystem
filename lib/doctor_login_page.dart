import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({super.key});

  @override
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  DatabaseReference doctordb = FirebaseDatabase.instance.ref("Doctor");
  final _formKey = GlobalKey<FormState>(); // Use a single form key
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;

  late int flag = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Login'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/login.png',
                alignment: Alignment.center,
                width: 100,
                height: 250,
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey, // Use the correct form key
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Doctor Username",
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
                          size: 50,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your username ";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "Doctor Password",
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
                          Icons.lock,
                          color: Colors.black,
                          size: 40,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Password ";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          doctordb.onValue.listen((event) {
                            flag = 0;
                            for (final doc in event.snapshot.children) {
                              Map<dynamic, dynamic> cl = doc.value as Map<dynamic, dynamic>;
                              if (cl['UserName'].toString().trim().compareTo(usernameController.text.trim()) == 0 &&
                                  cl['Password'].toString().trim().compareTo(passwordController.text.trim()) == 0) {
                                flag = 1;
                                var globalUserKey = doc.key as String;
                                var globalUserName = usernameController.text;
                                break;
                              }
                            }
                            if (flag == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login Successful!!')),
                              );
                              // Navigate to the next page if necessary
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Tabpage()),
                              // );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login failed, check username or password')),
                              );
                            }
                          }, onError: (error) {
                            print(error);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1557B0), // Dark blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
