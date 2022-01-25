import 'package:mcappen/Classes/Location.dart';

//typedef SetSearchResultCallback = Function(Location? location);
typedef SetSelectedLocation = Function(Location? location);
typedef LocationCallback = Function(Location location);
typedef SetSearchResultCallback = Function(Location? location);
typedef SetUserIsPlanning = Function(bool isUserPlanning);

typedef ClearSearchAtIndex = Function(int i);
typedef RemoveControllerAtIndex = Function(int i);
typedef SetPlanningSearchResultCallback = Function(Location? location, int i);