import 'package:flutter/material.dart';
import 'views/Home/Home.dart';

import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
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
