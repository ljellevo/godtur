
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/components/SearchResult.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Styles.dart';
import 'package:mcappen/utils/Typedefs.dart';
import 'package:mcappen/views/Favorites.dart';
import 'package:mcappen/views/Profile.dart';



class SearchUI extends StatefulWidget {
  final bool isUserSearching;
  final FocusNode focusNode;
  final TextEditingController searchController;
  final Network network;
  final Function cancelSearch;
  final Function clearSearch;
  final SetSearchResultCallback setSearchResult;
  final Icon suffixIcon;
  final LocationCallback moveCameraToLocation;
  final SetUserIsPlanning setUserIsPlanning;

  
  SearchUI({
    required this.isUserSearching,
    required this.focusNode,
    required this.searchController,
    required this.network,
    required this.cancelSearch,
    required this.clearSearch,
    required this.setSearchResult,
    required this.suffixIcon,
    required this.moveCameraToLocation,
    required this.setUserIsPlanning,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchUIState();
  }
}

class _SearchUIState extends State<SearchUI> {
  
  @override
  void dispose() {
    print("Disposing of SearchUI");
    super.dispose();
  }
  
  List<BoxShadow>? _containerBoxShadow() {
    if(widget.isUserSearching){
      return [BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ];
    } 
  }
  
  // margin: EdgeInsets.only(top: 0, bottom: 10),
  Widget searchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.isUserSearching ? Container(
          child: IconButton(
            iconSize: 35,
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              widget.cancelSearch();
            }
          ),
        ) : Container(),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: CupertinoTextField(
              
              focusNode: widget.focusNode,
              controller: widget.searchController,
              placeholder: "Søk etter lokasjon",
              style: TextStyle(color: Color(0xff0D2138)),
              prefix: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {}
                ),
              ),
              suffix: widget.searchController.value.text != "" ? Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    widget.clearSearch();
                  }
                ),
              ): null,
              padding: EdgeInsets.fromLTRB(0, 5, 15, 5),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: widget.isUserSearching ? Color(0xff0D2138) : Colors.transparent
                ),
                boxShadow: widget.isUserSearching ? null : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          )
        )
      ],
    );
  }
  
  
  Widget planTripButtonBar() {
    return ButtonBar( 
      alignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          style: Styles().lowProfileRoundButton(!widget.isUserSearching),
          child: Text("Avbryt", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
          onPressed: (){
            widget.setUserIsPlanning(false);
          },
        ),
        
      ],
    );
  }
    
  Widget buttonBar() {
    return ButtonBar( 
      alignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          style: Styles().lowProfileRoundButton(!widget.isUserSearching),
          child: Text("Planlegg", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
          onPressed: (){
            widget.setUserIsPlanning(true);
          },
        ),
        TextButton(
          style: Styles().lowProfileRoundButton(!widget.isUserSearching),
          child: Text("Favoritter", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorites()),
            );
          },
        ),
        TextButton(
          style: Styles().lowProfileRoundButton(!widget.isUserSearching),
          child: Text("Profil", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        )
      ],
    );
  }
  
  // PlanTrip
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.isUserSearching ? Colors.white : Colors.transparent,
            boxShadow: _containerBoxShadow()
          ),
          padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              searchBar(),
              widget.isUserSearching ? buttonBar() : Container()
            ],
          ),
        ),
        SearchResult(
          network: widget.network, 
          searchController: widget.searchController, 
          moveCameraToLocation: widget.moveCameraToLocation, 
          focusNode: widget.focusNode, 
          showSearchResult: widget.isUserSearching, 
          setSearchResult: widget.setSearchResult
        ),
      ],
    );
  }
}