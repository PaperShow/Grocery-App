import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/homeScreen.dart';
import 'package:grocery_app/screens/landing_screen.dart';
import 'package:grocery_app/screens/main_screen.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'Splash Screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    setState(() {});
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        } else {
          getUserData();
        }
      });
    });
  }

  getUserData() async {
    UserServices _userServices = UserServices();
    _userServices.getUserId(user!.uid).then((result) {
      //check location data
      if ((result.data() as dynamic)['address'] != null) {
        // if address details exists
        updatePrefs(result);
      }
      // if address not exists
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void> updatePrefs(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    await prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);
    // after update homeScreen
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'officialLogo',
          child: Image.network(
            'https://png.pngtree.com/png-clipart/20190419/ourlarge/pngtree-neon-error-404-page-png-image_943920.jpg',
            scale: 3,
          ),
        ),
      ),
    );
  }
}
