import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/provider/auth_provider.dart';
import 'package:grocery_app/provider/location_provider.dart';
import 'package:grocery_app/screens/homeScreen.dart';
import 'package:grocery_app/screens/landing_screen.dart';
import 'package:grocery_app/screens/logInScreen.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'Map Screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation = LatLng(37.421632, 122.084664);
  late GoogleMapController _mapController;
  bool _locating = true;

  bool _loggedIn = false;

  User? user;
  var featureName;
  var addressLine;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser as User;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 14.4746,
                ),
                zoomControlsEnabled: false,
                minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                onCameraMove: (CameraPosition position) {
                  setState(() {
                    _locating = true;
                  });
                  locationData.onCameraMove(position);
                },
                onMapCreated: onCreated,
                onCameraIdle: () {
                  setState(() {
                    _locating = false;
                  });
                  locationData.getMoveCamera();

                  setState(() {
                    featureName = locationData.selectedAddress.featureName;
                    addressLine = locationData.selectedAddress.addressLine;
                  });
                },
              ),
              Center(
                child: Image.asset(
                  'images/marker.png',
                  scale: 8,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      _locating
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColour),
                            )
                          : Container(),
                      TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.location_searching,
                            color: kPrimaryColour,
                          ),
                          label: Flexible(
                            child: Text(
                                _locating
                                    ? 'Locating....'
                                    : locationData.selectedAddress == null
                                        ? 'Locating...'
                                        : locationData
                                            .selectedAddress.featureName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 30)),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          _locating
                              ? ''
                              : locationData.selectedAddress == null
                                  ? ''
                                  : locationData.selectedAddress.addressLine,
                          maxLines: 2,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // save address in Shared Preference
                          locationData.savePrefs();
                          if (_loggedIn == false) {
                            Navigator.pushNamed(
                                // pushReplacementNamed
                                context,
                                LogInScreen.id);
                          } else {
                            setState(() {
                              auth.address =
                                  locationData.selectedAddress.addressLine;
                              auth.latitude = locationData.latitude;
                              auth.longitude = locationData.longitude;
                              auth.location =
                                  locationData.selectedAddress.featureName;
                            });
                            auth.updateUser(
                              id: user!.uid,
                              number: user!.phoneNumber,
                            );
                            Navigator.pushNamed(
                                context, MapScreen.id); // pushReplacementNamed
                          }
                        },
                        child: Text('Confirm Location'),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: _locating ? Colors.blue : Colors.orange,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width - 40, 50)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
