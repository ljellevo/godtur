
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/CalculatedRouteWithForecast.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/Classes/TextControllerLocation.dart';
import 'package:mcappen/Stateless/MediumButton.dart';
import 'package:mcappen/Stateless/MediumButton.dart';
import 'package:mcappen/Stateless/PlanTripSearchInputField.dart';
import 'package:mcappen/Stateless/SearchInputField.dart';
import 'package:mcappen/Stateless/SmallIconButton.dart';
import 'package:mcappen/Stateless/LocationTimeline.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Styles.dart';
import 'package:mcappen/widgets/PlanTrip.dart';


class PlanTripUI extends StatefulWidget {
  final List<TextEditingController> searchControllers;
  final CalculatedRouteWithForecast? route;
  final List<Location> locations;
  final Network network;
  final VoidCallback addDestination;
  final void Function(int) removeDestination;
  final void Function(int) onFieldTap;
  final void Function(int) clearField;
  final VoidCallback navigateBack;
  final void Function(int, int) reorderControllers;
  final TraficType traficType;
  final void Function(TraficType) changeTraficType;
  
  PlanTripUI({
    required this.searchControllers,
    required this.route,
    required this.locations,
    required this.network,
    required this.addDestination,
    required this.removeDestination,
    required this.onFieldTap,
    required this.clearField,
    required this.navigateBack,
    required this.reorderControllers,
    required this.traficType,
    required this.changeTraficType,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlanTripUIState();
  }
}


class _PlanTripUIState extends State<PlanTripUI> {
  List<TextEditingController> searchControllers = [];
  final ScrollController _scrollController = ScrollController();
  
  
  List<BoxShadow>? _containerBoxShadow() {
    return [BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      )
    ];
  }
  
  Widget planTripSearchBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumButton(
          icon: Icons.chevron_left, 
          onTap: widget.navigateBack
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints(maxHeight: 160),
            child: rearangeableList(),
          )
        )
      ],
    );
  }
  
  Widget controllerOptionButton(int i) {
    if(i == 0) {
      return  Container(
        child: SmallIconButton(
          icon: Icons.shuffle,
          onTap: (){
            widget.reorderControllers(i, i + 1);
          },
        ),
      );
    } else if (i == 1) {
      return Container(
        width: 65,
      );
    } else {
      return SmallIconButton(
        icon: Icons.clear,
        onTap: (){
          widget.removeDestination(i);
        },
      );
    }
  }
  
  Widget rearangeableList() {
    return ReorderableListView(
      scrollController: _scrollController,
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: (widget.searchControllers.length > 2) ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
      children: <Widget>[
        for (int i = 0; i < widget.searchControllers.length ; i++)
          Row(
            key: Key('$i'),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlanTripSearchInputField(
                focus: FocusNode(), 
                controller: widget.searchControllers[i],
                placeholder: "Søk etter lokasjon",
                index: i,
                readOnly: true,
                clearSearch: () {
                  widget.clearField(i);
                },
                onTap:  (){
                  widget.onFieldTap(i);
                },
              ),
              controllerOptionButton(i)
          ],
        ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          widget.reorderControllers(oldIndex, newIndex);
        });
      },
    );
  }
  
  Widget planTripButtonBar() {
    return Container(
      color: Colors.white,
      child: ButtonBar( 
        alignment: MainAxisAlignment.spaceAround,
        children: [
          SmallIconButton(
            icon: Icons.add_circle_outline, 
            onTap: () {
              WidgetsBinding.instance!.addPostFrameCallback((_) => {_scrollController.jumpTo(_scrollController.position.maxScrollExtent)});
              widget.addDestination();
            },
          ),
          SmallIconButton(
            selected: widget.traficType == TraficType.Driving,
            icon: Icons.drive_eta, 
            onTap: () {
              widget.changeTraficType(TraficType.Driving);
            },
          ),
          SmallIconButton(
            selected: widget.traficType == TraficType.Walking,
            icon: Icons.directions_walk, 
            onTap: () {
              widget.changeTraficType(TraficType.Walking);
            },
          ),
          SmallIconButton(
            selected: widget.traficType == TraficType.Cycling,
            icon: Icons.pedal_bike,
            onTap: () {
              widget.changeTraficType(TraficType.Cycling);
            },
          )
        ],
      ),
    );
  }
  
  Widget planTripResultList() {
    if(widget.route != null) {
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: LocationTimeline(
                route: widget.route!,
                locations: widget.locations,
              ),
              ),
            )
          )
        ],
      );
    } else {
      return Container();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: _containerBoxShadow()
          ),
          padding: EdgeInsets.fromLTRB(15, 56, 15, 0),
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              planTripSearchBars(),
              planTripButtonBar()
            ],
          ),
        ),
        Expanded(
          child: planTripResultList()
        )
      ],
    );
  }
}