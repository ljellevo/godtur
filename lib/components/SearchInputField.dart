import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:godtur/utils/Statics.dart';

class SearchInputField extends StatelessWidget {
  
  final FocusNode focus;
  final TextEditingController controller;
  final String placeholder;
  final bool actAsButton;
  
  final bool autoFocus;
  final bool readOnly;
  
  final VoidCallback? clearSearch;
  final VoidCallback? cancelSearch;
  final VoidCallback? onTap;
  

  

  // In the constructor, require a Todo.
  SearchInputField({
    required this.focus,
    required this.controller,
    required this.placeholder,
    this.actAsButton = false,
    
    this.autoFocus = false,
    this.readOnly = false,
    this.clearSearch,
    this.cancelSearch,
    this.onTap,
    Key? key
  }) : super(key: key);
  
  BoxDecoration applyCorrectDecoration() {
    if(actAsButton) {
      return BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.transparent
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      );
    } else {
      return BoxDecoration(
        border: Border.all(
          width: 2,
          color: Styles.primary
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: CupertinoTextField(
          autofocus: autoFocus,
          readOnly: readOnly,
          onTap: onTap,
          focusNode: focus,
          controller: controller,
          placeholder: placeholder,
          style: TextStyle(color: Styles.primary),
          prefix: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Styles.primary,
              ),
              onPressed: () {}
            ),
          ),
          suffix: controller.value.text != "" ? Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Styles.primary,
              ),
              onPressed: clearSearch
            ),
          ): null,
          padding: EdgeInsets.fromLTRB(0, 5, 15, 5),
          decoration: applyCorrectDecoration()
        ),
      )
    );
  }
}