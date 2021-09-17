import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/provider/auth_provider.dart';
import 'package:grocery_app/provider/location_provider.dart';
import 'package:grocery_app/screens/mapScreen.dart';
import 'package:grocery_app/screens/onBoarding_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome Screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    TextEditingController _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, myState) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: auth.error == 'Invalid OTP' ? false : true,
                  child: Container(
                    child: Text(auth.error),
                  ),
                ),
                Text('Login',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 50),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: _phoneNumberController,
                  onChanged: (value) {
                    if (value.length == 10) {
                      myState(() {
                        _validPhoneNumber = true;
                      });
                    } else {
                      myState(() {
                        _validPhoneNumber = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile number',
                    labelText: 'Mobile Number*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(),
                    prefix: Text(
                      '+91 | ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('By continuing, I agree to the'),
                    // Terms and Condition ---> will write in future
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            child: Column(
                              children: [
                                Text('Various Details'),
                                Text('..............'),
                                Text('..............'),
                                Text('..............'),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Accept'))
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Terms of Use\n & Privacy Policy',
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                AbsorbPointer(
                  absorbing: _validPhoneNumber ? false : true,
                  child: ElevatedButton(
                    onPressed: () {
                      myState(() {
                        auth.loading = true;
                      });
                      String number = '+91${_phoneNumberController.text}';
                      auth
                          .verifyPhone(
                        context: context,
                        number: number,
                        // latitude: null,
                        // longitude: null,
                        // address: null,
                      )
                          .then((value) {
                        _phoneNumberController.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: _validPhoneNumber
                            ? Colors.orange
                            : Colors.blueGrey),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: auth.loading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              _validPhoneNumber ? 'CONTINUE' : 'Enter number',
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: OnBoardingScreen(),
              ),
              SizedBox(height: 20),
              Text(
                'HyperLocal solution for Groceries',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Order from your nearest Shop',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      locationData.loading = true;
                    });

                    await locationData.getCurrentPosition();

                    if (locationData.permissionAllowed == true) {
                      // locationData.getCurrentPosition().then((value) {
                      //   Navigator.pushNamed(context, MapScreen.id);
                      //   setState(() {
                      //     locationData.loading = false;
                      //   });
                      // });        // isko bad mein dekte h tab tak niche wala apply kro navigator and setState

                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationData.loading = false;
                      });
                    } else {
                      print('Permission not allowed');
                      setState(() {
                        locationData.loading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(185, 20),
                    elevation: 0,
                  ),
                  child: locationData.loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('Set Location')),
              TextButton(
                onPressed: () {
                  setState(() {
                    auth.screen = 'Login';
                  });
                  showBottomSheet(context);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already a Customer ? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                          text: 'Login',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          Positioned(
            right: 0,
            top: 20,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Skip',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
