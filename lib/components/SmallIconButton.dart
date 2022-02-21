
import 'package:flutter/material.dart';
import 'package:mcappen/utils/Styles.dart';

class SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final bool? selected;
  
  SmallIconButton({
    required this.icon,
    required this.onTap,
    this.color = Styles.primary,
    this.selected = false,
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: !selected! ? Colors.white : Styles.primary,
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
