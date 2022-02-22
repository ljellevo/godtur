import 'package:flutter/material.dart';
import 'package:godtur/Classes/Location.dart';
import 'package:godtur/utils/Network.dart';
import 'package:godtur/utils/Typedefs.dart';
import 'package:godtur/views/Search/SearchUI.dart';



class Search extends StatefulWidget {
  final Network network;
  final SetSearchResultCallback? setSearchResult;
  final TextEditingController selectedLocationSearchController;
  final VoidCallback? textChanged;

  
  Search({
    required this.network,
    required this.selectedLocationSearchController,
    this.setSearchResult,
    this.textChanged,

    Key? key, 
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
  final focusNode = FocusNode();

  Location? _searchResult;
  
  @override
  void initState() {
    super.initState();
    widget.selectedLocationSearchController.addListener(textChanged);
  }
  
  @override
  void dispose() {
    widget.selectedLocationSearchController.removeListener(textChanged);
    super.dispose();
  }

  /// This function is called when the text in the searchfield changes. 
  /// It sets the correct icon for the right icon button
  void textChanged() {
    setState(() {});
  }
  
  /// onPress Functionality for the search/cancel icon button on the right hand side.
  void clearSearch() {
    setState(() {
      widget.selectedLocationSearchController.clear();
    });
    setSearchResult(null);
  }
  
  /// onPress Functionality for the "chevron" button on the left hand side. 
  /// This function tells the search component to hide the layover view as well as dismisses any potential keyboard.
  void cancelSearch() {
    Navigator.pop(context);
  }
  
  /// Sets selected search result and navigates map if location is not null.
  void setSearchResult(Location? location) {
    _searchResult = location;
    if(widget.setSearchResult != null) {
      widget.setSearchResult!(location);
    }
    if(location != null) {
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SearchUI(
        focusNode: focusNode,
        searchController: widget.selectedLocationSearchController,
        network: widget.network,
        cancelSearch: cancelSearch,
        clearSearch: clearSearch,
        setSearchResult: setSearchResult,
      ),
    );
  }
}





