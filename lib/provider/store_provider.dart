import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/services/store_services.dart';
import 'package:grocery_app/services/user_services.dart';

class StoreProvider with ChangeNotifier {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;

  Future<void> getUserLocationData(context) async {
    _userServices.getUserId(user!.uid).then((result) {
      if (user != null) {
        this.userLatitude = (result.data() as dynamic)['latitude'];
        this.userLongitude = (result.data() as dynamic)['longitude'];
        notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
  }
}
