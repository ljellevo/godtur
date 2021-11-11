import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




// ignore: slash_for_doc_comments
/**
 * Not currently in use
 */

class PlanTripButton extends StatefulWidget {
  PlanTripButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlanTripButtonState();
  }
}

class _PlanTripButtonState extends State<PlanTripButton> {
  TextEditingController searchController = TextEditingController();
  final focusNode = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('Button tapped');
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        height: 47,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
          "Planlegg tur",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15
          ),
          ),
        )
      ),
    );
  }
}