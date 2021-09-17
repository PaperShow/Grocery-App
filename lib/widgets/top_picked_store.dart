import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/provider/store_provider.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/services/store_services.dart';
import 'package:grocery_app/services/user_services.dart';
import 'package:provider/provider.dart';

class TopPickedStore extends StatefulWidget {
  const TopPickedStore({Key? key}) : super(key: key);

  @override
  _TopPickedStoreState createState() => _TopPickedStoreState();
}

class _TopPickedStoreState extends State<TopPickedStore> {
  StoreServices _storeServices = StoreServices();
  // UserServices _userServices = UserServices();
  // User? user = FirebaseAuth.instance.currentUser;
  // var _userLatitude = 0.0;
  // var _userLongitude = 0.0;

  //need to fing user lat/lon to find user distance
  // @override
  // void initState() {
  //   super.initState();
  //   _userServices.getUserId(user!.uid).then((result) {
  //     if (user != null) {
  //       setState(() {
  //         _userLatitude = (result.data() as dynamic)['latitude'];
  //         _userLongitude = (result.data() as dynamic)['longitude'];
  //       });
  //     } else {
  //       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final _storeData = Provider.of<StoreProvider>(context);

    _storeData.getUserLocationData(context);

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(_storeData.userLatitude,
          _storeData.userLongitude, location.latitude, location.longitude);
      var distInKm = distance / 1000;
      return distInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _storeServices.getTopPickedStore(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator());

            List shopDistance = [];
            for (var i = 0; i < snapshot.data!.docs.length - 1; i++) {
              var distance = Geolocator.distanceBetween(
                  _storeData.userLatitude,
                  _storeData.userLongitude,
                  (snapshot.data as QuerySnapshot).docs[i]['location'].latitude,
                  (snapshot.data as QuerySnapshot)
                      .docs[i]['location']
                      .longitude);
              var distanceInKm = distance / 1000;
              shopDistance.add(distanceInKm);
            }
            shopDistance.sort();
            if (shopDistance[0] > 10) {
              return Container(
                width: size.width,
                margin:
                    EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
                child: Center(
                  child: Flexible(
                    child: Text(
                      'Currently not serving in your area, try another location',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                  ),
                ),
              );
            }
            return Container(
              color: Colors.white,
              height: 210,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/like.gif',
                          scale: 4,
                        ),
                        Text(
                          'Top Picks for you',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        if (double.parse(getDistance(document['location'])) <=
                            10) {
                          // show stores within 10 km  ~can be increase or decrease
                          return Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 100,
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: 90,
                                      height: 85,
                                      child: Card(
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.network(
                                                document['imageUrl'],
                                                fit: BoxFit.fill,
                                              )))),
                                  Container(
                                    // height: 35,
                                    child: Text(
                                      document['shopName']
                                          .toString()
                                          .toUpperCase(),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    '${getDistance(document['location'])}Km',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  )
                                ],
                              ));
                        } else {
                          return Container(
                            child: Text('No shops near by you'),
                          );
                        }
                      }).toList() as dynamic,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
