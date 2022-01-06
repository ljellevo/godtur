import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Layover extends StatefulWidget {
  Layover({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LayoverState();
  }
}

class _LayoverState extends State<Layover> {
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        renderPanelSheet: false,
        parallaxEnabled: true,
        borderRadius: radius,
        minHeight: 200,
        panel: _floatingPanel(),
        collapsed: _floatingCollapsed(),
      );
  }
  
  Widget _floatingCollapsed(){
  return Container(
    decoration: BoxDecoration(
      color: Colors.blueGrey,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
    ),
    margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
    child: Center(
      child: Text(
        "This is the collapsed Widget",
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
  
  Widget _floatingPanel(){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(24.0)),
      boxShadow: [
        BoxShadow(
          blurRadius: 20.0,
          color: Colors.grey,
        ),
      ]
    ),
    margin: const EdgeInsets.all(24.0),
    child: Center(
      child: Text("This is the SlidingUpPanel when open"),
    ),
  );
}
}



//