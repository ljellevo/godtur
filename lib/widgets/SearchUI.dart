
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcappen/Stateless/MediumButton.dart';
import 'package:mcappen/Stateless/SearchInputField.dart';
import 'package:mcappen/components/SearchResult.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Typedefs.dart';



class SearchUI extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController searchController;
  final Network network;
  final VoidCallback cancelSearch;
  final VoidCallback clearSearch;
  final SetSearchResultCallback setSearchResult;

  SearchUI({
    required this.focusNode,
    required this.searchController,
    required this.network,
    required this.cancelSearch,
    required this.clearSearch,
    required this.setSearchResult,
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
    super.dispose();
  }
  
  List<BoxShadow>? _containerBoxShadow() {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      )
    ];
  }
  
  
  Widget searchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [  
        MediumButton(
          icon: Icons.chevron_left,
          onTap: widget.cancelSearch,
        ),
        SearchInputField(
          focus: widget.focusNode, 
          controller: widget.searchController, 
          placeholder: "Søk etter lokasjon",
          clearSearch: widget.clearSearch, 
          cancelSearch: widget.cancelSearch,
          autoFocus: true,
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
            color: Colors.white,
            boxShadow: _containerBoxShadow()
          ),
          padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              searchBar(),
            ],
          ),
        ),
        SearchResult(
          network: widget.network, 
          searchController: widget.searchController, 
          focusNode: widget.focusNode, 
          setSearchResult: widget.setSearchResult
        ),
      ],
    );
  }
}