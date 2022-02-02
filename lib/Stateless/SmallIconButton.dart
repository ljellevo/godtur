
import 'package:flutter/material.dart';

class SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final bool? selected;
  
  SmallIconButton({
    required this.icon,
    required this.onTap,
    this.color = const Color(0xff0D2138),
    this.selected = false,
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: !selected! ? Colors.white : Color(0xff0D2138),
        shape: CircleBorder(),
      ),
      child: Icon(
        icon,
        size: 22,
        color: !selected! ? color : Colors.white,
      ),
      onPressed: onTap,
    );
  }
}
