import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mcappen/widgets/TextEntryField.dart';

class SearchComponent extends StatefulWidget {
  SearchComponent({Key? key}) : super(key: key);
  

  @override
  State<StatefulWidget> createState() {
    return _SearchComponentState();
  }
}

class _SearchComponentState extends State<SearchComponent> {
  Color _containerColor = Colors.transparent;
  bool _showSearchResult = false;
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  TextEditingController searchController = TextEditingController();
  
  void searchbarFocusChanged(FocusNode focus) {
    setState(() {
      _containerColor = focus.hasFocus ? Colors.white : Colors.transparent;
      _showSearchResult = focus.hasFocus;
    });
  }
  
  void searchFieldChanged(String text) {

    setState(() {
      _containerColor = text != "" ? Colors.white : Colors.transparent;
      _showSearchResult = text != "" ? true : false;
    });
  }
  
  
  void isSearchActive(bool focus) {
    print("Search state changed");
    setState(() {
      _containerColor = focus ? Colors.white : Colors.transparent;
      _showSearchResult = focus;
    });
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
                color: Colors.amber[colorCodes[index]],
                child: Center(child: Text('Entry ${entries[index]}')),
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
            color: _containerColor,
            padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
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