
import 'package:flutter/material.dart';

class MediumButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  MediumButton({
    required this.icon,
    required this.onTap,
    this.color = const Color(0xff0D2138),
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        iconSize: 35,
        icon: Icon(icon),
        color: color,
        onPressed: onTap
      ),
    );
  }
}