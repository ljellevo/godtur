import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Typedefs.dart';




class SearchResult extends StatefulWidget {
  final Network network;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final SetSearchResultCallback setSearchResult;
  
  SearchResult({
    required this.network,
    required this.searchController,
    required this.focusNode,
    required this.setSearchResult,
  Key? key
  }) : super(key: key);
  

  @override
  State<StatefulWidget> createState() {
    return _SearchResultState();
  }
}

class _SearchResultState extends State<SearchResult> {
  List<Location> locations = [];
  
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(searchFieldChanged);
  }
  
  @override
  void dispose() {
    widget.searchController.removeListener(searchFieldChanged);
    super.dispose();
  }
  
  /// Called whenever text in the text entry field changes
  void searchFieldChanged() async {
    if(widget.searchController.value.text != "") {
      locations = await widget.network.getLocationBySearch(widget.searchController.value.text);
    } else {
      locations = [];
    }
    if (!mounted) return;
    setState(() {
      locations = locations;
    });
  }
  
  Widget searchResultList() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: locations.length,
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(
              child: listCell(i),
              onTap: () {
                widget.setSearchResult(locations[i]);
              }
            );
          }
        ),
      )
    );
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
    return searchResultList();
  }
}