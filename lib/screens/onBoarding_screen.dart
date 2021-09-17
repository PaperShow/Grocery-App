import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:grocery_app/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _controller = PageController(
    initialPage: 0,
  );
  static const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 26);
  List<Widget> _pageView = [
    Column(
      children: [
        Expanded(
          child: Image.asset('images/set_location.png'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Set your delivery Location',
            style: textStyle,
          ),
        )
      ],
    ),
    Column(
      children: [
        Expanded(child: Image.asset('images/favourite_store.png')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('Order Online from favourite store',
              textAlign: TextAlign.center, style: textStyle),
        )
      ],
    ),
    Column(
      children: [
        Expanded(child: Image.asset('images/online_delivery.jpg')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Quick delivery to Doorstep ', style: textStyle),
        )
      ],
    ),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pageView,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
          SizedBox(height: 50),
          DotsIndicator(
            dotsCount: _pageView.length,
            position: currentPage.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeColor: Theme.of(context).primaryColor,
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
