import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/widgets/TextEntryField.dart';

class SearchComponent extends StatefulWidget {
  final Network network;
  SearchComponent({
    required this.network,
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
  List<Location> entries = [];
  //final List<int> colorCodes = <int>[600, 500, 100];
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    searchController.addListener(searchFieldChanged);
  }
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
  void searchbarFocusChanged(FocusNode focus) {
    setState(() {
      _containerColor = focus.hasFocus ? Colors.white : Colors.transparent;
      _showSearchResult = focus.hasFocus;
    });
  }
  
  void searchFieldChanged() async {
    List<Location> locations = [];
    if(searchController.value.text != "") {
      locations = await widget.network.getLocationBySearch(searchController.value.text);
    }
    setState(() {
      _containerColor = searchController.value.text != "" ? Colors.white : Colors.transparent;
      _showSearchResult = searchController.value.text != "" ? true : false;
      entries = locations;
    });
  }
  
  
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
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 500,
                child: Center(child: Text('Entry ${entries[index].name}')),
              );
            }
          ),
        )
      );
    }
    return Container();
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
              searchController: searchController,
              searchActiveState: isSearchActive,
            )
          ),
        )
      ],
    );
  }
}