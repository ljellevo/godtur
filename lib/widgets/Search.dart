import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/components/SearchResult.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Styles.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:mcappen/views/Favorites.dart';
import 'package:mcappen/views/Profile.dart';

typedef SetSelectedLocation = Function(Location? location);

class Search extends StatefulWidget {
  final Network network;
  final LocationCallback moveCameraToLocation;
  final SetSelectedLocation setSelectedLocation;
  final Location? selectedLocation;
  Search({
    required this.network,
    required this.moveCameraToLocation,
    required this.setSelectedLocation,
    required this.selectedLocation,
    Key? key
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
  bool _isUserSearching = false;
  
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
    setState(() {
      _searchResult = location;
      new Utils().setTextInTextField(searchController, _searchResult != null ? _searchResult!.name : "");
      _isUserSearching = false;
    });
    if(_searchResult != null) {
      focusNode.unfocus();
      widget.moveCameraToLocation(_searchResult!);
    }
  }
  
  List<BoxShadow>? _containerBoxShadow() {
    if(_isUserSearching){
      return [BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ];
    } 
  }
  
  Widget searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          CupertinoTextField(
            focusNode: focusNode,
            controller: searchController,
            placeholder: "Søk etter lokasjon",
            style: TextStyle(color: Color(0xff0D2138)),
            prefix: _isUserSearching ? Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: cancelSearch
              ),
            ) : null,
            suffix: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: IconButton(
                icon: _suffixIcon,
                onPressed: () {
                  clearSearch();
                }
              ),
            ),
            padding: _isUserSearching ? EdgeInsets.fromLTRB(0, 15, 15, 15) : EdgeInsets.fromLTRB(47, 15, 15, 15),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: _isUserSearching ? Colors.grey.withOpacity(0.5) : Colors.transparent
              ),
              boxShadow: _isUserSearching ? null : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              
            ),
          ),
          ButtonBar( 
            alignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: Styles().lowProfileRoundButton(!_isUserSearching),
                child: Text("Planlegg", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
                onPressed: (){},
              ),
              TextButton(
                style: Styles().lowProfileRoundButton(!_isUserSearching),
                child: Text("Favoritter", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favorites()),
                  );
                },
              ),
              TextButton(
                style: Styles().lowProfileRoundButton(!_isUserSearching),
                child: Text("Profil", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              )
            ],
          )
        ],
      )
    );
  }
  
  /*
  SizedBox(
              width: 100,
                height: 25,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){},
                  child: Text("Planlegg", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
                  color: Colors.white
                )
              ),
              SizedBox(
              width: 100,
                height: 25,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){},
                  child: Text("Favoritter", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
                  color: Colors.white
                )
              ),
              SizedBox(
              width: 100,
                height: 25,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){},
                  child: Text("Profil", style: TextStyle(color: Color(0xff0D2138), fontSize: 13)),
                  color: Colors.white
                )
              ),
  
  */
  
  @override
  Widget build(BuildContext context) {
    _searchResult = widget.selectedLocation;
    return Stack(
      fit: StackFit.loose,
      children: [
        SearchResult(
          network: widget.network, 
          searchController: searchController, 
          moveCameraToLocation: widget.moveCameraToLocation, 
          focusNode: focusNode, 
          showSearchResult: _isUserSearching, 
          setSearchResult: setSearchResult
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: _isUserSearching ? Colors.white : Colors.transparent,
              boxShadow: _containerBoxShadow()
            ),
            padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: searchBar()
          )
        ),
      ],
    );
  }
}





