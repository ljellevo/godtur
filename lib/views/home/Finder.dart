import 'package:flutter/material.dart';
import 'package:godtur/Classes/Location.dart';
import 'package:godtur/components/SearchInputField.dart';
import 'package:godtur/utils/Network.dart';
import 'package:godtur/utils/Typedefs.dart';
import 'package:godtur/utils/Utils.dart';
import 'package:godtur/views/Search/Search.dart';

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
  TextEditingController selectedLocationTextController = TextEditingController();
  
  void clearSearch() {
    setSearchResult(null);
  }
  
  /// Sets selected search result and navigates map if location is not null.
  void setSearchResult(Location? location) {
    setState(() {
      selectedLocationTextController.text = location != null ? location.name : "";
      new Utils().setTextInTextField(selectedLocationTextController, location != null ? location.name : "");
    });
    widget.setSelectedLocation(location);
    if(location != null) {
      widget.moveCameraToLocation(location);
    }
  }
  
  void navigateToSearch() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Search(
          network: widget.network,
          setSearchResult: setSearchResult,
          selectedLocationSearchController: selectedLocationTextController,
        )
      ),
    );
  }
   // Theme.of(context).backgroundColor
   
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 20,
      right: 20,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchInputField(
            focus: FocusNode(), 
            controller: selectedLocationTextController, 
            placeholder: "Søk etter lokasjon",
            readOnly: true,
            actAsButton: true,
            clearSearch: clearSearch,
            onTap: navigateToSearch,
          )
        ],
      ),
    );
  }
}



