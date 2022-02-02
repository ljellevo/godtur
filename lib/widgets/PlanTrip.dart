import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/widgets/PlanTripUI.dart';
import 'package:mcappen/widgets/Search.dart';



class PlanTrip extends StatefulWidget {
  final Network network;
  final Location? selectedLocation;
  final UserLocation? userLocation;

  PlanTrip({
    required this.network,
    required this.selectedLocation,
    required this.userLocation,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlanTripState();
  }
}

enum TraficType {  
   Driving,
   Walking,
   Cycling,
}

class _PlanTripState extends State<PlanTrip> {
  List<TextEditingController> searchControllers = [];
  List<LocationForecast> forecasts = [];
  TraficType traficType = TraficType.Driving;
  
  @override
  void initState() {
    super.initState();
    TextEditingController myLocation = new TextEditingController();
    myLocation.text = "Min lokasjon";
    searchControllers.add(myLocation);
    getCurrentLocationForecast();
    TextEditingController destination = new TextEditingController();
    if(widget.selectedLocation != null) {
      destination.text = widget.selectedLocation!.name;
      getLocationForecast(widget.selectedLocation!);
    }
    searchControllers.add(destination);
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  void onFieldTap(int i) {    
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Search(
          network: widget.network,
          setSearchResult: (Location? location) {
            setSearchResult(location, i);
          },
          selectedLocationSearchController: searchControllers[i],
          textChanged: textChanged,
        )
      ),
    );
  }
  
  void navigateBack() {
    Navigator.pop(context);
  }
  
  void textChanged() {
    setState(() {});
  }
  
  void clearField(int i) {
    setState(() {
      searchControllers[i].clear();
    });
  }
  
  void addDestination() {
    if(searchControllers[searchControllers.length - 1].value.text != "") {
      setState(() {
        searchControllers.add(TextEditingController());
      });
    }
  }
  
  void removeDestination(int i) {
    setState(() {
      if(forecasts.length < i) {
        forecasts.removeAt(i);
      }
      searchControllers.removeAt(i);
      sortForecasts();
    });
  }
  
  void reorderControllers(int oldIndex, int newIndex) {
    final TextEditingController item = searchControllers.removeAt(oldIndex);
    setState(() {
      searchControllers.insert(newIndex, item);
    });
    sortForecasts();
  }
  
  void setSearchResult(Location? location, int i) {
    setState(() {
      if(location != null){
        searchControllers[i].text = location.name;
        getLocationForecast(location);
      } else {
        searchControllers[i].text = "";
      }
    });
  }
  
  void getCurrentLocationForecast() async {
    if(widget.userLocation != null) {
      LocationForecast? forecast = await widget.network.getAllForecastForSpecificCoordinates(widget.userLocation!.position);
      if(forecast != null) {
        forecasts.add(forecast);
        sortForecasts();
      }
    }
  }
  
  void getLocationForecast(Location location) async {
    LocationForecast? forecast = await widget.network.getAllForecastForSpecificLocation(location);
    if(forecast != null) {
      forecasts.add(forecast);
      sortForecasts();
    }
  }
  
  void sortForecasts() {
    List<LocationForecast> sorted = [];
    for(var controller in searchControllers) {
      for(var forecast in forecasts) {
        if(controller.text == forecast.name){
          sorted.add(forecast);
        }
      }
    }                     
    setState(() {
      forecasts = sorted;
    });
  }
  
  void changeTraficType(TraficType newType) {
    setState(() {
      traficType = newType;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: PlanTripUI(
        searchControllers: searchControllers,
        forecasts: forecasts,
        network: widget.network,
        addDestination: addDestination,
        removeDestination: removeDestination,
        onFieldTap: onFieldTap,
        clearField: clearField,
        navigateBack: navigateBack,
        reorderControllers: reorderControllers,
        traficType: traficType,
        changeTraficType: changeTraficType,
      ),
    );
  }
}





