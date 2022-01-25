import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Typedefs.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:mcappen/widgets/PlanTrip.dart';
import 'package:mcappen/widgets/PlanTripUI.dart';
import 'package:mcappen/widgets/SearchUI.dart';



class Search extends StatefulWidget {
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
  
  Search({
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
    Key? key, 
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
  Icon _suffixIcon = Icon(Icons.search);
  final focusNode = FocusNode();
  Location? _searchResult;
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusListener);
    searchController.addListener(textChanged);
  }
  
  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  
  /// Engages the search view when the text entry field is focused and keybaord appears.
  void focusListener() { 
    if(focusNode.hasFocus){
      showSearchLayover();
    } 
  }
  
  /// This function is called when the text in the searchfield changes. 
  /// It sets the correct icon for the right icon button
  void textChanged() {
    setState(() {
      _suffixIcon = searchController.value.text == "" ? Icon(Icons.search) : Icon(Icons.cancel);
    });
  }
  
  /// onPress Functionality for the search/cancel icon button on the right hand side.
  void clearSearch() {
    searchController.clear();
    setSearchResult(null);
    showSearchLayover();
  }
  
  /// onPress Functionality for the "chevron" button on the left hand side. 
  /// This function tells the search component to hide the layover view as well as dismisses any potential keyboard.
  void cancelSearch() {
    focusNode.unfocus();
    widget.cancelSearch();
  }
  
  void showSearchLayover() {
    widget.showSearchLayover();
  }
  
  void hideSearchLayover() {
    widget.hideSearchLayover();
  }
  
  /// Sets selected search result and navigates map if location is not null.
  void setSearchResult(Location? location) {
    setState(() {
      _searchResult = location;
      new Utils().setTextInTextField(searchController, _searchResult != null ? _searchResult!.name : "");
    });
    if(_searchResult != null) {
      focusNode.unfocus();
      widget.moveCameraToLocation(_searchResult!);
    }
    widget.setSearchResult(location);
  }
  
  void setUserIsPlanning(bool isUserPlanning) {
    widget.setUserIsPlanning(isUserPlanning);
  }
  
  @override
  Widget build(BuildContext context) {
    return SearchUI(
      isUserSearching: widget.isUserSearching,
      focusNode: focusNode,
      searchController: searchController,
      network: widget.network,
      cancelSearch: cancelSearch,
      clearSearch: clearSearch,
      setSearchResult: setSearchResult,
      suffixIcon: _suffixIcon,
      moveCameraToLocation: widget.moveCameraToLocation,
      setUserIsPlanning: setUserIsPlanning,
    );
  }
}





