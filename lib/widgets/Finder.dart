import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Typedefs.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:mcappen/widgets/PlanTrip.dart';
import 'package:mcappen/widgets/PlanTripUI.dart';
import 'package:mcappen/widgets/Search.dart';
import 'package:mcappen/widgets/SearchUI.dart';



class Finder extends StatefulWidget {
  final Network network;
  final LocationCallback moveCameraToLocation;
  final SetSelectedLocation setSelectedLocation;
  final Location? selectedLocation;
  Finder({
    required this.network,
    required this.moveCameraToLocation,
    required this.setSelectedLocation,
    required this.selectedLocation,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FinderState();
  }
}

class _FinderState extends State<Finder> {
  Icon _suffixIcon = Icon(Icons.search);
  Location? _searchResult;
  bool _isUserSearching = false;
  
  
  /// onPress Functionality for the search/cancel icon button on the right hand side.
  void clearSearch() {
    setSearchResult(null);
    showSearchLayover();
  }
  
  /// onPress Functionality for the "chevron" button on the left hand side. 
  /// This function tells the search component to hide the layover view as well as dismisses any potential keyboard.
  void cancelSearch() {
    hideSearchLayover();
  }
  
  void showSearchLayover() {
    setState(() {
      _isUserSearching = true;
    });
  }
  
  void hideSearchLayover() {
    setState(() {
      _isUserSearching = false;
    });    
  }
  

  
  /// Sets selected search result and navigates map if location is not null.
  void setSearchResult(Location? location) {
    widget.setSelectedLocation(location);
    hideSearchLayover();
    if(_searchResult != null) {
      widget.moveCameraToLocation(_searchResult!);
    }
  }
  
  void setUserIsPlanning(bool isUserPlanning) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlanTrip(
        setSelectedLocation: widget.setSelectedLocation,
        isUserSearching: _isUserSearching,
        network: widget.network,
        cancelSearch: cancelSearch,
        clearSearch: clearSearch,
        setSearchResult: setSearchResult,
        suffixIcon: _suffixIcon,
        moveCameraToLocation: widget.moveCameraToLocation,
        setUserIsPlanning: setUserIsPlanning,
        showSearchLayover: showSearchLayover,
        hideSearchLayover: hideSearchLayover,
        selectedLocation: widget.selectedLocation,
      )
    ),
  );
  }
  
  @override
  Widget build(BuildContext context) {
    _searchResult = widget.selectedLocation;
    return Search(
      setSelectedLocation: widget.setSelectedLocation,
      isUserSearching: _isUserSearching,
      network: widget.network,
      cancelSearch: cancelSearch,
      clearSearch: clearSearch,
      setSearchResult: setSearchResult,
      suffixIcon: _suffixIcon,
      moveCameraToLocation: widget.moveCameraToLocation,
      setUserIsPlanning: setUserIsPlanning,
      showSearchLayover: showSearchLayover,
      hideSearchLayover: hideSearchLayover,
    );
  }
}





