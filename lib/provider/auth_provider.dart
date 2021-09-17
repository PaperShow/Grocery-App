import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/provider/location_provider.dart';
import 'package:grocery_app/screens/homeScreen.dart';
import 'package:grocery_app/screens/landing_screen.dart';
import 'package:grocery_app/screens/main_screen.dart';
import 'package:grocery_app/screens/mapScreen.dart';
import 'package:grocery_app/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  var smsOtp; // ispe nazar rakhna  aur niche wale pr--> ? may be used
  var verificationId;
  String error = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  var screen;
  var latitude;
  var longitude;
  var address;
  var location;

  Future<void> verifyPhone({context, number}) async {
    this.loading = true;
    notifyListeners();

    final verificationCompleted = (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential).then((value) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;

      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
        this.error = e.toString();
        notifyListeners();
      }
    };

    final PhoneCodeSent smsOtpSent = (String verId, int? resendToken) async {
      this.verificationId = verId;

      // Dialog box appears to enter received otp sms

      smsOtpDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSent,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<dynamic> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text('Verification code'),
            SizedBox(height: 6),
            Text('Enter 6 digit code'),
          ],
        ),
        content: Container(
          height: 85,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: (value) {
              this.smsOtp = value;
            },
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: smsOtp);
                  final user = (await _auth.signInWithCredential(credential))
                      .user as User;

                  // Create user data in fireStore after user successfully register
                  // if (locationData.selectedAddress != null) {
                  //   updateUser(
                  //       id: user.uid,
                  //       number: user.phoneNumber,
                  //       latitude: locationData.latitude,
                  //       longitude: locationData.longitude,
                  //       address: locationData.selectedAddress.addressLine);
                  // } else {
                  //   _createUser(
                  //       id: user.uid,
                  //       number: user.phoneNumber,
                  //       latitude: latitude,
                  //       longitude: longitude,
                  //       address: address);
                  // }

                  // Navigate to Home Page after login

                  if (user != null) {
                    this.loading = false;
                    notifyListeners();
                    // Navigator.of(context).pop();
                    // Navigator.pushReplacementNamed(context, HomeScreen.id);
                    _userServices.getUserId(user.uid).then((snapShot) {
                      if (snapShot.exists) {
                        if (this.screen == 'Login') {
                          // need to check user data already exists in db or not
                          // if its 'login' , no new data , so no need to update
                          if ((snapShot.data() as dynamic)['address'] != null) {
                            Navigator.pushReplacementNamed(
                                context, MainScreen.id);
                          }
                          Navigator.pushReplacementNamed(
                              context, LandingScreen.id);
                        } else {
                          //need to update new selected address
                          updateUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(
                              context, MainScreen.id);
                        }
                      } else {
                        // user data does not exists
                        // will create new data in db
                        _createUser(id: user.uid, number: user.phoneNumber);
                        Navigator.pushReplacementNamed(
                            context, LandingScreen.id);
                      }
                    });
                  } else {
                    print('login failed');
                  }
                } catch (e) {
                  this.error = 'Invalid OTP';
                  this.loading = false;
                  notifyListeners();
                  print(e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: Text('Done')),
        ],
      ),
    ).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({id, number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location
      // 'latitude': locationData.latitude,
      // 'longitude': locationData.longitude,
      // 'address': locationData.selectedAddress == null
      //     ? locationData.selectedAddress
      //     : locationData.selectedAddress.addressLine
    });
    this.loading = false;
    notifyListeners();
  }

  Future<void> updateUser({id, number}) async {
    _userServices.updateUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location
    });
    this.loading = false;
    notifyListeners();
  }
}
