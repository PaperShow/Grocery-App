import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/main.dart';
import 'package:grocery_app/provider/auth_provider.dart';
import 'package:grocery_app/provider/location_provider.dart';
import 'package:grocery_app/screens/mapScreen.dart';
import 'package:grocery_app/widgets/near_by_stores.dart';
import 'package:grocery_app/widgets/top_picked_store.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/widgets/appBar.dart';
import 'package:grocery_app/widgets/imageSlider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home Screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, bool innerBoxIsScrolled) {
          return [MyAppBar()];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 0),
          children: [
            ImageSlider(),
            Container(
              child: TopPickedStore(),
            ),
            SizedBox(
              height: 5,
            ),
            Container(color: Colors.white, child: NearByStores()),
          ],
        ),
      ),
    );
  }
}
