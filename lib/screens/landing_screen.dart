import 'package:flutter/material.dart';
import 'package:grocery_app/provider/location_provider.dart';
import 'package:grocery_app/screens/main_screen.dart';
import 'package:grocery_app/screens/mapScreen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'Landing Screen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;
  // User? user = FirebaseAuth.instance.currentUser;
  // var _location;
  // var _address;
  // @override
  // void initState() {
  //   super.initState();
  //   UserServices _userServices = UserServices();
  //   _userServices.getUserId(user!.uid).then((result) async {
  //     if (result != null) {
  //       if ((result.data() as dynamic)['latitude'] != null) {
  //         getPrefs(result);
  //       } else {
  //         _locationProvider.getCurrentPosition();
  //         if (_locationProvider.permissionAllowed == true) {
  //           Navigator.pushReplacementNamed(context, MapScreen.id);
  //         } else {
  //           print('permission not allowed');
  //         }
  //       }
  //     }
  //   });
  // }

  // getPrefs(dbResult) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? location = prefs.getString('location');
  //   if (location == null) {
  //     prefs.setString('address', dbResult.data()['location']);
  //     prefs.setString('location', dbResult.data()['address']);
  //     if (mounted) {
  //       setState(() {
  //         _location = dbResult.data()['location'];
  //         _address = dbResult.data()['address'];
  //       });
  //     }
  //     Navigator.pushReplacementNamed(context, HomeScreen.id);
  //   }
  //   Navigator.pushReplacementNamed(context, HomeScreen.id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delivery address not set',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Please update your Delivery location to find nearest stores for you',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black38),
              ),
            ),
            // CircularProgressIndicator(),
            Container(
                child: Image.asset(
              'images/city.png',
              fit: BoxFit.fill,
              // color: Colors.black12,
            )),
            Visibility(
              // visible: _location != null ? true : false,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, MainScreen.id);
                  },
                  child: Text('Confirm Your Location')),
            ),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: Colors.lightGreen),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      await _locationProvider.getCurrentPosition();
                      if (_locationProvider.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          if (_locationProvider.permissionAllowed == false) {
                            print('permission not allowed');
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Please allow permission to find nearest store')));
                          }
                        });
                      }
                    },
                    child: Text(
                      'Set Your Location',
                      style: TextStyle(fontSize: 18),
                    ))
          ],
        ),
      ),
    );
  }
}
