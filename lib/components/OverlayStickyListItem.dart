import 'package:flutter/widgets.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

class OverlayStickyListItem<int> extends InfiniteListItem<int> {

  /// If header should overlay content or not
  @override
  final bool overlayContent = true;
  
  Widget Function(BuildContext) contentBuilder;
  Widget Function(BuildContext)? headerBuilder;
  Widget Function(BuildContext, StickyState<int>)? headerStateBuilder;
  double? Function(StickyState<int>)? minOffsetProvider;
  HeaderMainAxisAlignment mainAxisAlignment = HeaderMainAxisAlignment.start;
  HeaderCrossAxisAlignment crossAxisAlignment = HeaderCrossAxisAlignment.start;
  HeaderPositionAxis positionAxis = HeaderPositionAxis.mainAxis;
  EdgeInsets? padding;

  OverlayStickyListItem({
      required this.contentBuilder,
      this.headerBuilder,
      this.headerStateBuilder,
      this.minOffsetProvider,
      this.mainAxisAlignment = HeaderMainAxisAlignment.start,
      this.crossAxisAlignment = HeaderCrossAxisAlignment.start,
      this.positionAxis = HeaderPositionAxis.mainAxis,
      this.padding,
  }

  ) : super(
    contentBuilder: contentBuilder,
    headerStateBuilder: headerStateBuilder,
    minOffsetProvider: minOffsetProvider,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    positionAxis: positionAxis,
    padding: padding,
  );


}