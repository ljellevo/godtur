
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/TextControllerFocus.dart';
import 'package:mcappen/components/PlanTripResult.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Styles.dart';
import 'package:mcappen/utils/Typedefs.dart';
import 'package:mcappen/views/Favorites.dart';
import 'package:mcappen/views/Profile.dart';



class PlanTripUI extends StatefulWidget {
  final bool isUserSearching;
  final TextControllerFocus activeController;
  final List<TextControllerFocus> searchControllers;
  final Network network;
  final Function cancelSearch;
  final ClearSearchAtIndex clearSearch;
  final Function addController;
  final RemoveControllerAtIndex removeController;
  final SetPlanningSearchResultCallback setSearchResult;
  final Icon suffixIcon;
  final LocationCallback moveCameraToLocation;

  
  PlanTripUI({
    required this.isUserSearching,
    required this.activeController,
    required this.searchControllers,
    required this.network,
    required this.cancelSearch,
    required this.clearSearch,
    required this.addController,
    required this.removeController,
    required this.setSearchResult,
    required this.suffixIcon,
    required this.moveCameraToLocation,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlanTripUIState();
  }
}

class _PlanTripUIState extends State<PlanTripUI> {
  List<TextControllerFocus> searchControllers = [];
  TextControllerFocus? activeController;
  
  void searchFieldChanged() {
    setState(() {
      searchControllers = widget.searchControllers;
    });
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
  
  
  Widget planTripSearchBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: IconButton(
            iconSize: 35,
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              widget.cancelSearch();
            }
          ),
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints(maxHeight: 160),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: searchControllers.length,
              physics: (searchControllers.length > 3) ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int i) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: CupertinoTextField(
                          focusNode: searchControllers[i].getFocus(),
                          controller: searchControllers[i].getController(),
                          placeholder: "Søk etter lokasjon",
                          style: TextStyle(color: Color(0xff0D2138)),
                          prefix: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IconButton(
                              iconSize: 22,
                              icon: Icon(Icons.search),
                              onPressed: () {}
                            ),
                          ),
                          suffix: searchControllers[i].getController().value.text != "" ? Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IconButton(
                              iconSize: 22,
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                searchControllers[i].getController().clear();
                              }
                            ),
                          ): null,
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.2,
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
                    ),
                    i > 0 ? Container(
                      child: IconButton(
                        iconSize: 22,
                        icon: Icon(Icons.clear),
                        color: Color(0xff0D2138).withOpacity(0.5),
                        onPressed: () {
                          widget.removeController(i);
                        }
                      ),
                    ) : Container(width: 50,),
                  ],
                );
              },
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
          child: Text("Legg til", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
          onPressed: (){
            widget.addController();
          },
        ),
        TextButton(
          style: Styles().lowProfileRoundButton(!widget.isUserSearching),
          child: Text("Lag rute", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
          onPressed: (){
            
          },
        ),
      ],
    );
  }
  
  // PlanTrip
  @override
  Widget build(BuildContext context) {
    searchControllers = widget.searchControllers;
    activeController = widget.activeController;
    
    /*
    for(var controller in widget.searchControllers) {
      controller.getController().addListener(searchFieldChanged);
    }
    */
    
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.isUserSearching ? Colors.white : Colors.transparent,
            boxShadow: _containerBoxShadow()
          ),
          padding: EdgeInsets.fromLTRB(15, 56, 15, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              planTripSearchBars(),
              planTripButtonBar()
            ],
          ),
        ),
        PlanTripResult(
          network: widget.network, 
          searchController: widget.activeController.getController(), 
          moveCameraToLocation: widget.moveCameraToLocation, 
          focusNode: widget.activeController.getFocus(), 
          showSearchResult: widget.isUserSearching, 
          setSearchResult: widget.setSearchResult
        ),
      ],
    );
  }
}