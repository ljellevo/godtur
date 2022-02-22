import 'package:flutter/material.dart';
import 'package:godtur/components/Loading.dart';
import 'package:godtur/utils/Statics.dart';
import 'package:godtur/views/plan_trip/cards/DismissableCard.dart';
import 'package:godtur/views/plan_trip/cards/DistanceDurationCard.dart';
import 'package:godtur/views/plan_trip/cards/MapCard.dart';
import 'package:godtur/views/plan_trip/cards/OpenNavigationCard.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:godtur/Classes/CalculatedRouteWithForecast.dart';
import 'package:godtur/Classes/Location.dart';
import 'package:godtur/Classes/RouteLinesAndBounds.dart';
import 'package:godtur/components/MediumButton.dart';
import 'package:godtur/views/plan_trip/PlanTrip.dart';
import 'package:godtur/views/plan_trip/PlanTripSearchInputField.dart';
import 'package:godtur/views/plan_trip/cards/SummaryCard.dart';
import 'package:godtur/components/SmallIconButton.dart';
import 'package:godtur/views/plan_trip/cards/LocationTimelineCard.dart';
import 'package:godtur/utils/Network.dart';


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
  final void Function(MapboxMapController) onMapLoaded;
  final RouteLinesAndBounds routeLinesAndBounds;
  final void Function() onMapIdle;
  
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
    required this.onMapLoaded,
    required this.routeLinesAndBounds,
    required this.onMapIdle,
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
                placeholder: Statics.SEARCHFIELD_PLACEHOLDER_TEXT,
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
            color: Styles.secondary,
            icon: Icons.add_circle_outline, 
            onTap: () {
              WidgetsBinding.instance!.addPostFrameCallback((_) => {_scrollController.jumpTo(_scrollController.position.maxScrollExtent)});
              widget.addDestination();
            },
          ),
          SmallIconButton(
            selected: widget.traficType == TraficType.Driving,
            icon: Icons.drive_eta, 
            color: Styles.secondary,
            onTap: () {
              widget.changeTraficType(TraficType.Driving);
            },
          ),
          SmallIconButton(
            selected: widget.traficType == TraficType.Walking,
            icon: Icons.directions_walk, 
            color: Styles.secondary,
            onTap: () {
              widget.changeTraficType(TraficType.Walking);
            },
          ),
          SmallIconButton(
            selected: widget.traficType == TraficType.Cycling,
            icon: Icons.pedal_bike,
            color: Styles.secondary,
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
        padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
        children: [
          DissmissableCard(text: Statics.INFORMATION_DISSMISSABLE_CARD_MESSAGE, onPressed: (){},),
          SummaryCard(route: widget.route!),
          LocationTimelineCard(route: widget.route!),
          DistanceDurationCard(route: widget.route!),
          MapCard(route: widget.route!, onMapLoaded: widget.onMapLoaded, onMapIdle: widget.onMapIdle),
          OpenNavigationCard(route: widget.route!)
        ],
      );
    } else {
      if(widget.locations.length < 2) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Styles.secondary,
              ),
              Text(
                Statics.LESS_THAN_TWO_LOCATIONS_MESSAGE,
                style: TextStyle(
                  color: Styles.accent
                ),
              )
            ],
          ),
        );
      } else {
        return Loading();
      }
    }
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: widget.searchControllers.length == 2 ? 220 : 270),
            child: planTripResultList(),
          )
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: _containerBoxShadow()
          ),
          
          padding: EdgeInsets.fromLTRB(15, 56, 15, 0),
          //margin: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              planTripSearchBars(),
              planTripButtonBar()
            ],
          ),
        ),
      ],
    );
  }
}