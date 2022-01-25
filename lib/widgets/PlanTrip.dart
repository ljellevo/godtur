import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/TextControllerFocus.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Typedefs.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:mcappen/widgets/PlanTripUI.dart';



class PlanTrip extends StatefulWidget {
  final SetSelectedLocation setSelectedLocation;
  final bool isUserSearching;
  final Network network;
  final Function cancelSearch;
  final Function clearSearch;
  final SetSearchResultCallback setSearchResult;
  final Icon suffixIcon;
  final LocationCallback moveCameraToLocation;
  final SetUserIsPlanning setUserIsPlanning;
  final Function showSearchLayover;
  final Function hideSearchLayover;
  final Location? selectedLocation;

  PlanTrip({
    required this.setSelectedLocation,
    required this.isUserSearching,
    required this.network,
    required this.cancelSearch,
    required this.clearSearch,
    required this.setSearchResult,
    required this.suffixIcon,
    required this.moveCameraToLocation,
    required this.setUserIsPlanning,
    required this.showSearchLayover,
    required this.hideSearchLayover,
    required this.selectedLocation,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlanTripState();
  }
}

class _PlanTripState extends State<PlanTrip> {
  Icon _suffixIcon = Icon(Icons.search);
  TextControllerFocus? activeController;
  List<TextControllerFocus> searchControllers = [];
  bool userIsPlanning = false;
  
  @override
  void initState() {
    super.initState();
    searchControllers.add(createController("Min posisjon"));
    if(widget.selectedLocation != null) {
      searchControllers.add(createController(widget.selectedLocation!.name));
    } else {
      searchControllers.add(createController(null));
    }
    activeController = searchControllers[searchControllers.length - 1];
    
    
  }
  
  @override
  void dispose() {
    for(var searchController in searchControllers) {
      searchController.getController().dispose();
      searchController.getFocus().dispose();
    }
    super.dispose();
  }
  
  TextControllerFocus createController(String? text) {
    TextEditingController myLocation = new TextEditingController();
    myLocation.text = text != null ? text : "";
    
    FocusNode focus = new FocusNode();
    focus.addListener(textEntryFieldFocusChanged);
    return TextControllerFocus(controller: myLocation, focus: focus);
  }
  
  void textEntryFieldFocusChanged() {
    print("Focus changed");
    for(var controller in searchControllers) {
      if(controller.getFocus().hasFocus) {
        setState(() {
          activeController = controller;
        });
      }
    }
  }
  
  
  /// onPress Functionality for the search/cancel icon button on the right hand side.
  void clearSearch(i) {
    searchControllers[i].getController().clear();
    setSearchResult(null, i);
  }
  
  /// onPress Functionality for the "chevron" button on the left hand side. 
  /// This function tells the search component to hide the layover view as well as dismisses any potential keyboard.
  void cancelSearch() {
    widget.cancelSearch();
    Navigator.pop(context);
  }

  
  void addController() {
    setState(() {
      searchControllers.add(createController(null));
    });
  }
  
  void removeController(int i) {
    setState(() {
      searchControllers.removeAt(i);
    });
  }
  
  ///
  void setSearchResult(Location? location, int index) {
    searchControllers[index].getController().text = location != null ? location.name : "";
    searchControllers[index].setLocation(location);
  }
  
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(activeController!.getFocus());
    return Material(
      child: PlanTripUI(
        isUserSearching: widget.isUserSearching,
        activeController: activeController!,
        searchControllers: searchControllers,
        network: widget.network,
        cancelSearch: cancelSearch,
        clearSearch: clearSearch,
        addController: addController,
        removeController: removeController,
        setSearchResult: setSearchResult,
        suffixIcon: _suffixIcon,
        moveCameraToLocation: widget.moveCameraToLocation,
      ),
    );
  }
}





