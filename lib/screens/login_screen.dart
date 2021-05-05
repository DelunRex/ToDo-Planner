import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_planner/constants.dart';
import 'package:task_planner/screens/home_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String em;
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _loginKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Task Planner",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (val.isEmpty) {
                            return 'Please enter your email';
                          } else if (!regex.hasMatch(val)) {
                            return 'Enter valid email';
                          } else {
                            email = val;
                          }
                        },
                        decoration: inputdecoration.copyWith(
                          hintText: "Enter your email",
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                            LoginScreen.em = email;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.length < 6 ? 'Wrong Password' : null,
                        decoration: inputdecoration.copyWith(
                            hintText: "Enter your password"),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          elevation: 5.0,
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(30.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final newUser =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  if (newUser != null) {
                                    Navigator.pushReplacementNamed(
                                        context, HomeScreen.id);
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  var errorcode = e.code;
                                  if (errorcode == 'wrong-password') {
                                    _loginKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text("Wrong Password")));
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } else if (errorcode == 'user-not-found') {
                                    _loginKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text("No user found")));
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }
                                  print(e);
                                }
                              }
                            },
                            height: 42.0,
                            minWidth: 200.0,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
