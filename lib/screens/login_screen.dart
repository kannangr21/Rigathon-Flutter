import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:torq_rig22/screens/home_screen.dart';

import '../services/google_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  void login() async {
    setState(() {
      isLoading = true;
    });
    await GoogleAuth().loginWithGoogle();
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      setState(() {
        borderVisible = false;
      });
      _btnController.success();
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
      );
    } else {
      buttonErrorReset();
    }
  }

  void buttonErrorReset() async {
    setState(() {
      borderVisible = false;
    });
    _btnController.error();
    await Future.delayed(
      Duration(seconds: 2),
    );

    _btnController.reset();
    setState(() {
      isLoading = false;
      borderVisible = true;
    });
  }

  bool isLoading = false;
  bool borderVisible = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RiGathon '22",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Team TORQ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome,",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Login to continue",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: borderVisible
                          ? Color(0xFF666CDB)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: RoundedLoadingButton(
                    animateOnTap: false,
                    color: Colors.white,
                    duration: Duration(
                      seconds: 2,
                    ),
                    onPressed: login,
                    controller: _btnController,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google_logo.png",
                          height: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        isLoading
                            ? SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                "Continue with Google",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
