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
  
  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusListener);
  }
  
  void focusListener() {
    print(widget.searchController.value.text);
    if(widget.searchController.value.text == "") {
      widget.searchActiveState(false);
    }
    
    if(focusNode.hasFocus || widget.searchController.value.text != "") {
      setState(() {
        widget.searchActiveState(true);
        _suffixIcon = Icon(Icons.cancel);
      });
    } else {
      setState(() {
        widget.searchActiveState(false);
        _suffixIcon = Icon(Icons.search);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CupertinoTextField(
      focusNode: focusNode,
      controller: widget.searchController,
      placeholder: "Søk etter lokasjon",
      suffix: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: IconButton(
          icon: _suffixIcon,
          onPressed: () {
            widget.searchController.clear();
            focusNode.unfocus();
            focusListener();
          },
        ),
      ),
      padding: EdgeInsets.fromLTRB(25, 15, 15, 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
    ),
    );
  }
}


