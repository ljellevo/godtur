import 'package:flutter/material.dart';
import 'views/Home/Home.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: MaterialApp(
        title: 'Flutter Demo',
       theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
        ),
        
        home: HomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
