import 'package:flutter/material.dart';
import 'package:godtur/utils/Statics.dart';

class DissmissableCard extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  DissmissableCard({
    required this.text,
    required this.onPressed
  });
  
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Styles.secondary,
                      ),
                      onPressed: onPressed,
                    ),
                  ],
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 22,
                    color: Styles.primaryVariant
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}