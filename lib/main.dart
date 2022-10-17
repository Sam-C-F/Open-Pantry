import 'package:flutter/material.dart';
import 'package:open_pantry/pages/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  MaterialColor maincolor = MaterialColor(
    0xff79b465,
    <int, Color>{
      50: Color(0xff79b465),
      100: Color(0xff79b465),
      200: Color(0xff79b465),
      300: Color(0xff79b465),
      400: Color(0xff79b465),
      500: Color(0xff79b465),
      600: Color(0xff79b465),
      700: Color(0xff79b465),
      800: Color(0xff79b465),
      900: Color(0xff79b465),
    },
  );
  MaterialColor secondcolor = MaterialColor(
    0xffFDF5E6,
    <int, Color>{
      50: Color(0xffFDF5E6),
      100: Color(0xffFDF5E6),
      200: Color(0xffFDF5E6),
      300: Color(0xffFDF5E6),
      400: Color(0xffFDF5E6),
      500: Color(0xffFDF5E6),
      600: Color(0xffFDF5E6),
      700: Color(0xffFDF5E6),
      800: Color(0xffFDF5E6),
      900: Color(0xffFDF5E6),
    },
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: maincolor, backgroundColor: secondcolor),
          
          // textTheme: ,
        ),
        home: const HomeScreen());
  }
}
