import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:torq_rig22/screens/home_screen.dart';
import 'package:torq_rig22/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String getInitialRoute() {
    FirebaseAuth _authInstance = FirebaseAuth.instance;
    if (_authInstance.currentUser == null) {
      return "login";
    } else {
      return "/";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TORQ-Rig22',
      initialRoute: '/', //home
      routes: {
        "/": (context) => HomeScreen(),
        "login": (context) => LoginScreen(),
      },
    );
  }
}
