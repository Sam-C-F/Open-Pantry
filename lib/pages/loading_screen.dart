import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:async';

import 'package:open_pantry/pages/home_screen.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 5),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())));
    return Scaffold(
        backgroundColor: Color(0xffFDF5E6),
        body: Column(children: [
          Center(child: Image.asset('assets/images/picwish.png')),
          Expanded(
              child: Text('\n\nBought to you by\n.Team{} Productions',
                  style: TextStyle(
                      fontFamily: 'Josefin',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Color(0xff79b465))))
        ]));
  }
}
