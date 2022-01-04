import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/utils/CameraManager.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/widgets/TextEntryField.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef LocationCallback = Function(Location location);

class SearchComponent extends StatefulWidget {
  final Network network;
  final TextEditingController searchController;
  final LocationCallback moveCameraToLocation;
  SearchComponent({
    required this.network,
    required this.searchController,
    required this.moveCameraToLocation,
    Key? key
    }) : super(key: key);
  

  @override
  State<StatefulWidget> createState() {
    return _SearchComponentState();
  }
}

class _SearchComponentState extends State<SearchComponent> {
  Color _containerColor = Colors.transparent;
  bool _showSearchResult = false;
  List<Location> locations = [];
  final focusNode = FocusNode();
  
  
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(searchFieldChanged);
  }
  
  @override
  void dispose() {
    widget.searchController.dispose();
    super.dispose();
  }
  
  /// Called whenever text in the text entry field changes
  void searchFieldChanged() async {

    if(widget.searchController.value.text != "") {
      locations = await widget.network.getLocationBySearch(widget.searchController.value.text);
    }
    setState(() {
      locations = locations;
    });
  }
  
  /// Shows/hides the search layover view
  void isSearchActive(bool focus) {
    setState(() {
      _containerColor = focus ? Colors.white : Colors.transparent;
      _showSearchResult = focus;        
    });
  }
  
  List<BoxShadow>? _containerBoxShadow() {
    if(_showSearchResult){
      return [BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ];
    } 
  }
  
  Widget searchResult() {
    if(_showSearchResult) {
      return Positioned.fill(
        top: 100,
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: locations.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: listCell(index),
                onTap: () {
                  isSearchActive(false);
                  focusNode.unfocus();
                  widget.moveCameraToLocation(locations[index]);
                }
              );
            }
          ),
        )
      );
    }
    return Container();
  }
  
  
  Widget listCell(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          )
        ),
      child: Row(
        children: [
          Image.asset(
            "assets/system-icons/" + locations[index].locationType + "-strek.png",
            width: 35,
            height: 35,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      locations[index].name,
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    locations[index].alternativeNames.length != 0 ? Text(
                      " (" + locations[index].alternativeNames.join(" - ") + ")",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12
                      ),
                    ) : Container(),
                  ],
                ),
                
                Text(
                  locations[index].municipality,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12
                  ),
                ),
                Row(
                  children: [
                    Text(
                      locations[index].county,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        searchResult(),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: _containerColor,
              boxShadow: _containerBoxShadow()
            ),
            padding: EdgeInsets.fromLTRB(15, 50, 15, 15),
            child: TextEntryField(
              searchController: widget.searchController,
              searchActiveState: isSearchActive,
              focusNode: focusNode,
            )
          ),
        )
      ],
    );
  }
}