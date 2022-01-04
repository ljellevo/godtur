import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextEntryField extends StatefulWidget {
  final Function searchActiveState;
  final TextEditingController searchController;
  final FocusNode focusNode;
  TextEntryField({
    required this.searchActiveState, 
    required this.searchController, 
    required this.focusNode,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextEntryFieldState();
  }
}

class _TextEntryFieldState extends State<TextEntryField> {
  
  Icon _suffixIcon = Icon(Icons.search);
  bool _isSearchActive = false;
  
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(focusListener);
    widget.searchController.addListener(textChanged);
  }
  
  @override
  void dispose() {
    widget.searchController.dispose();
    widget.focusNode.dispose();
    super.dispose();
  }
  
  /// Engages the search view when the text entry field is focused and keybaord appears.
  void focusListener() {    
    if(widget.focusNode.hasFocus) {
      setState(() {
        widget.searchActiveState(true);
        _isSearchActive = true;
      });
    }
  }
  
  /// This function is called when the text in the searchfield changes. It sets the correct icon for the right icon button
  void textChanged() {
    setState(() {
      _suffixIcon = widget.searchController.value.text == "" ? Icon(Icons.search) : Icon(Icons.cancel);
    });
  }
  
  /// Functionality for the search/cancel icon button on the right hand side.
  void clearSearch() {
    widget.searchController.clear();
    setState(() {
      widget.searchActiveState(true);
      _isSearchActive = true;
    });
  }
  
  /// Functionality for the "chevron" button on the left hand side. This function tells the search component to hide the layover view as well as dismisses any potential keyboard.
  void cancelSearch() {
    widget.searchController.clear();
    widget.focusNode.unfocus();
    setState(() {
      widget.searchActiveState(false);
      _isSearchActive = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CupertinoTextField(
      focusNode: widget.focusNode,
      controller: widget.searchController,
      placeholder: "Søk etter lokasjon",
      prefix: _isSearchActive ? Container(
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
      padding: _isSearchActive ? EdgeInsets.fromLTRB(0, 15, 15, 15) : EdgeInsets.fromLTRB(47, 15, 15, 15),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: _isSearchActive ? Colors.grey.withOpacity(0.5) : Colors.transparent
        ),
        boxShadow: _isSearchActive ? null : [
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
    );
  }
}


