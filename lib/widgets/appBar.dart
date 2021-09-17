import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/provider/location_provider.dart';
import 'package:grocery_app/screens/mapScreen.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String? _location;
  String? _address;
  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');
    String? location = prefs.getString('location');
    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      // expandedHeight: 200,
      backgroundColor: Colors.lightGreen,
      title: TextButton(
        onPressed: () {
          locationData.getCurrentPosition();
          if (locationData.permissionAllowed == true) {
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: MapScreen.id),
              screen: MapScreen(),
              withNavBar: false, // as map screen is outside of bottom nav bar
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          } else {
            print('permission not allowed');
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Text(
                    _location == null ? 'Address not set' : '$_location',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ],
            ),
            Text(
              _address == null ? 'Set Location' : '$_address',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            )
          ],
        ),
      ),
      // actions: [], used to add widget at last in appBar
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200]),
          ),
        ),
      ),
    );
  }
}
