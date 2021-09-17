import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  CarouselController buttonCarouselController = CarouselController();
  var _dataLength = 1;
  var _index = 0;
  var slides;
  @override
  void initState() {
    getSliderImageFromDB();
    super.initState();
  }

  Future getSliderImageFromDB() async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore.collection('slider').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getSliderImageFromDB(),
              builder: (context, AsyncSnapshot snap) {
                List slideList = snap.data.toList();
                if (snap.hasError) {
                  return Text('Something went wrong  ${snap.error}');
                }
                return snap.data == null
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: CarouselSlider.builder(
                          itemCount: slideList.length,
                          itemBuilder: (context, index, page) {
                            return SizedBox(
                              width: double.infinity,
                              child: Image.network(
                                slideList[index]['image'],
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width * 0.9,
                              ),
                            );
                          },
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            viewportFraction: 1,
                            initialPage: 0,
                            autoPlay: true,
                            height: 155,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _index = index;
                              });
                            },
                          ),
                        ),
                      );
              },
            ),
          DotsIndicator(
            dotsCount: _dataLength,
            position: _index.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(7.0),
              activeColor: Theme.of(context).primaryColor,
              activeSize: const Size(20.0, 6.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }
}
