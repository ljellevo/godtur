import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextEntryField extends StatefulWidget {
  final Function searchActiveState;
  final TextEditingController searchController;
  TextEntryField({required this.searchActiveState, required this.searchController, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextEntryFieldState();
  }
}

class _TextEntryFieldState extends State<TextEntryField> {
  final focusNode = FocusNode();
  Icon _suffixIcon = Icon(Icons.search);
  bool _isSearchActive = false;
  
  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusListener);
    widget.searchController.addListener(textChanged);
  }
  
  void focusListener() {    
    if(focusNode.hasFocus || widget.searchController.value.text != "") {
      setState(() {
        widget.searchActiveState(true);
        _isSearchActive = true;
      });
    }
  }
  
  void textChanged() {
    setState(() {
      _suffixIcon = widget.searchController.value.text == "" ? Icon(Icons.search) : Icon(Icons.cancel);
    });
  }
  
  void cancelSearch() {
    widget.searchController.clear();
    focusNode.unfocus();
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
      focusNode: focusNode,
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
            widget.searchController.clear();
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


