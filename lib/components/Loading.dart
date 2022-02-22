import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child:  Image.asset(
          "assets/animations/loading.webp",
        ),
      ),
    );
  }
}