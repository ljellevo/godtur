import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanTripSearchInputField extends StatelessWidget {
  
  final FocusNode focus;
  final TextEditingController controller;
  final String placeholder;
  final int index;
  
  final bool actAsButton;
  final bool autoFocus;
  final bool readOnly;
  
  final VoidCallback? clearSearch;
  final VoidCallback? cancelSearch;
  final VoidCallback? onTap;
  
  PlanTripSearchInputField({
    required this.focus,
    required this.controller,
    required this.placeholder,
    required this.index,
    
    this.actAsButton = false,
    
    this.autoFocus = false,
    this.readOnly = false,
    this.clearSearch,
    this.cancelSearch,
    this.onTap,
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: CupertinoTextField(
          enableInteractiveSelection: false,
          autofocus: autoFocus,
          readOnly: readOnly,
          onTap: onTap,
          focusNode: focus,
          controller: controller,
          placeholder: placeholder,
          style: TextStyle(color: Color(0xff0D2138)),
          prefix: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ReorderableDragStartListener(
              index: index,
              child: IconButton(
                iconSize: 22,
                icon: Icon(Icons.drag_handle),
                onPressed: () {}
              ),
            ),
          ),
          suffix: controller.value.text != "" ? Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: IconButton(
              iconSize: 22,
              icon: Icon(Icons.cancel),
              onPressed: clearSearch
            ),
          ): null,
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.2,
              color: Color(0xff0D2138)
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
      )
    );
  }
}

/*

*/