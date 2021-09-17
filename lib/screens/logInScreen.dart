import 'package:flutter/material.dart';
import 'package:grocery_app/provider/auth_provider.dart';
import 'package:grocery_app/provider/location_provider.dart';
import 'package:grocery_app/screens/homeScreen.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'LogIn Screen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  var _validPhoneNumber = false;
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
        body: SafeArea(
      child: Container(
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 50),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              controller: _phoneNumberController,
              onChanged: (value) {
                if (value.length == 10) {
                  setState(() {
                    _validPhoneNumber = true;
                  });
                } else {
                  setState(() {
                    _validPhoneNumber = false;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter Mobile number',
                labelText: 'Mobile Number*',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                        color: Colors.orange[800], fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            AbsorbPointer(
              absorbing: _validPhoneNumber ? false : true,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    auth.loading = true;
                    auth.screen = 'MapScreen';
                    auth.address = locationData.selectedAddress.addressLine;
                    auth.latitude = locationData.latitude;
                    auth.longitude = locationData.longitude;
                  });
                  String number = '+91${_phoneNumberController.text}';
                  auth
                      .verifyPhone(
                    context: context,
                    number: number,
                  )
                      .then((value) {
                    _phoneNumberController.clear();
                    setState(() {
                      auth.loading = false;
                    });
                  });
                  // Navigator.pushNamed(context, HomeScreen.id);  -- bina otp ke homeScreen pahunch gaye
                },
                style: ElevatedButton.styleFrom(
                    primary:
                        _validPhoneNumber ? Colors.orange : Colors.blueGrey),
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
    ));
  }
}
