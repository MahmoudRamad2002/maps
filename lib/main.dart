import 'package:flutter/material.dart';
import 'package:gps/ui/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
      homeScreen.routeName:(_)=>homeScreen()
      },
      initialRoute:homeScreen.routeName ,
    );
  }
}

