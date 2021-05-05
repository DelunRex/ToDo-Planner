import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_planner/screens/home_screen.dart';
import 'package:task_planner/screens/login_screen.dart';
import 'package:task_planner/screens/registration_screen.dart';
import 'package:task_planner/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TaskPlanner());
}

class TaskPlanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*   Future<User> getCurrentUser() async {
      User user = await FirebaseAuth.instance.currentUser;
      if (user == null) {
        initialRoute:
        WelcomeScreen.id;
      } else {
        initialRoute:
        HomeScreen.id;
      }
    }*/

    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
