import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
              tag: 'officialLogo',
              child: Image.network(
                'https://png.pngtree.com/png-clipart/20190419/ourlarge/pngtree-neon-error-404-page-png-image_943920.jpg',
                scale: 5,
              ))
        ],
      ),
    );
  }
}
