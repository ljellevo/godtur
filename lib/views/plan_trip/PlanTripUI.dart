
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/CalculatedRouteWithForecast.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/Classes/RouteLinesAndBounds.dart';
import 'package:mcappen/Classes/TextControllerLocation.dart';
import 'package:mcappen/components/MediumButton.dart';
import 'package:mcappen/components/MediumButton.dart';
import 'package:mcappen/views/plan_trip/PlanTrip.dart';
import 'package:mcappen/views/plan_trip/PlanTripSearchInputField.dart';
import 'package:mcappen/views/plan_trip/SummaryCard.dart';
import 'package:mcappen/components/SearchInputField.dart';
import 'package:mcappen/components/SmallIconButton.dart';
import 'package:mcappen/views/plan_trip/LocationTimeline.dart';
import 'package:mcappen/components/TemperatureText.dart';
import 'package:mcappen/assets/Secrets.dart';
import 'package:mcappen/utils/CameraManager.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Styles.dart';


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
        padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
        children: [
          SummaryCard(route: widget.route!),
          Card(
            child: Container(
              padding: EdgeInsets.all(20),
              child: LocationTimeline(
                route: widget.route!,
              ),
            )
          ),
          Card(
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  //Text("Oppsummering"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.route!.getTotalDistance().toString(),
                            style: TextStyle(
                              fontSize: 34
                            ),
                          )
                        ],
                      ),
                      //Icon(Icons.keyboard_arrow_up)
                      Column(
                        children: [
                          Text(
                            widget.route!.getTotalDuration().toString(),
                            style: TextStyle(
                              fontSize: 34
                            ),
                          )
                        ],
                      ),
                      
                    ],
                  ),
                  Text(
                    "(Distanse og tid er kun estimater)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                  )
                ],
              ),
            )
          ),
          Card(
            child: Container(
              height: 400,
              child: MapboxMap(
                accessToken: Secrets.MAPBOX_ACCESS_TOKEN,
                onMapCreated: widget.onMapLoaded,
                initialCameraPosition: CameraPosition(target: LatLng( widget.route!.locations[widget.route!.locations.length - 1].geoJson.coordinates[0][1],  widget.route!.locations[widget.route!.locations.length - 1].geoJson.coordinates[0][0]), zoom: 10),
                styleString: Secrets.MAPBOX_STYLE_URL,
                onCameraIdle: widget.onMapIdle,
                compassEnabled: false,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                tiltGesturesEnabled: false,
                //cameraTargetBounds: CameraTargetBounds(LatLngBounds(southwest: widget.southwest!, northeast: widget.northeast!)),
              ),
            )
          ),
          Card(
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  //Text("Oppsummering"),
                  Text(
                    "Navigasjon N/A",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.grey
                    ),
                  ),
                  Text(
                    "Åpner google maps",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      );
    } else {
      return Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child:  CircularProgressIndicator(
            value: null,
            strokeWidth: 5.0,
            color: Colors.black,
          )
        ),
      );
    }
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Container(
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