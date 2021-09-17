import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/provider/store_provider.dart';
import 'package:grocery_app/services/store_services.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/framework.dart';

class NearByStores extends StatefulWidget {
  @override
  _NearByStoresState createState() => _NearByStoresState();
}

class _NearByStoresState extends State<NearByStores> {
  StoreServices _storeServices = StoreServices();
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
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
        stream: _storeServices.getNearByStore(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          List shopDistance = [];
          for (var i = 0; i < snapshot.data!.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                _storeData.userLatitude,
                _storeData.userLongitude,
                (snapshot.data as QuerySnapshot).docs[i]['location'].latitude,
                (snapshot.data as QuerySnapshot).docs[i]['location'].longitude);
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if (shopDistance[0] > 10) {
            return Container(
              color: Colors.red,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '"That\'s all folks"',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    ),
                  ),
                  Image.asset(
                    'images/city.png',
                    color: Colors.black12,
                  ),
                  Positioned(
                      right: 10,
                      top: 80,
                      child: Container(
                        width: 100,
                        child: Column(
                          children: [
                            Text(
                              'Made by : ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              'Abher',
                              style: TextStyle(
                                  fontFamily: 'Anton',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(10),
            child: RefreshIndicator(
              onRefresh: () async {
                refreshChangeListener.refreshed = true;
              },
              child: PaginateFirestore(
                bottomLoader: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                header: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Nearby Stores',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Findout quality products near you',
                          style: kstoreTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilderType: PaginateBuilderType.listView,
                itemBuilder: (index, context, document) => Padding(
                  padding: EdgeInsets.all(4),
                  child: Container(
                    // width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 110,
                          child: Card(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    (document.data() as dynamic)['imageUrl'],
                                    fit: BoxFit.fill,
                                  ))),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                document['shopName'].toString().toUpperCase(),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text((document.data() as dynamic)['dialog'],
                                style: kstoreTextStyle),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                document['address'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: kstoreTextStyle,
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              child: Text(
                                '${getDistance(document['location'])}Km',
                                overflow: TextOverflow.ellipsis,
                                style: kstoreTextStyle,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                Text(
                                  document['rating'].toString(),
                                  style: kstoreTextStyle,
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                query: _storeServices.getNearByStorePaginQuery(),
                listeners: [refreshChangeListener],
                footer: SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              '"That\'s all folks"',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black54),
                            ),
                          ),
                          Image.asset(
                            'images/city.png',
                            color: Colors.black12,
                          ),
                          Positioned(
                              right: 10,
                              top: 80,
                              child: Container(
                                width: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      'Made by : ',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Text(
                                      'Abher',
                                      style: TextStyle(
                                          fontFamily: 'Anton',
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
