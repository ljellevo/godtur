import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:godtur/Classes/CalculatedRouteWithForecast.dart';
import 'package:godtur/Classes/Forecast.dart';
import 'package:godtur/Classes/Location.dart';
import 'package:godtur/Classes/LocationForecast.dart';
import 'package:godtur/Classes/Token.dart';
import 'package:godtur/views/plan_trip/PlanTrip.dart';

class Network {
  
  Token? token;
  
  Future<Token> getToken() async {
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/oauth2/token?grant_type=client_credentials&client_id=000000&client_secret=999999&scope=read'));
    return Token.fromJson(jsonDecode(response.body));
  }
  
  Future<Token> validateToken() async {
    if(token == null) {
      token = await getToken();
    } else {
      if (token!.expires < (DateTime.now().millisecondsSinceEpoch/1000)){
        token = await getToken();
      }
    }
    return token!;
  }
  
  Future<List<Location>> getLocationsWithinViewportBounds(LatLngBounds bounds) async {
    await validateToken();
    String lowLat = bounds.southwest.latitude.toString();
    String lowLon = bounds.southwest.longitude.toString();
    String uppLat = bounds.northeast.latitude.toString();
    String uppLon = bounds.northeast.longitude.toString();
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/locations?method=bounds&lowLat=' + lowLat + '&lowLon=' + lowLon + '&uppLat=' + uppLat + '&uppLon=' + uppLon + '&access_token=' + token!.accessToken));
    if(response.body != "null" && response.statusCode == 200) {
      Iterable locationResponse  = json.decode(response.body) as Iterable;
      List<Location> locations = List<Location>.from(locationResponse.map<Location>((dynamic i) => Location.fromJson(i as Map<String, dynamic>)));
      return locations;
      }
    return [];
  }
  
  
  Future<Location?> getLocationByCoordinate(UserLocation location) async {
    await validateToken();
    String lat = location.position.latitude.toString();
    String lon = location.position.longitude.toString();
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/locations?method=coordinate&latitude=' + lat + '&longitude=' + lon + '&access_token=' + token!.accessToken));
    if(response.body != "null" && response.statusCode == 200) {
      return Location.fromJson(json.decode(response.body));
    }
    return null;
  }
  
  Future<List<Location>> getLocationBySearch(String searchValue) async {
    await validateToken();
    try {
      http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/locations/search?name=' + searchValue + '&access_token=' + token!.accessToken));
      if(response.statusCode == 200) {
        if(response.body != "null") {
          Iterable locationResponse  = json.decode(response.body) as Iterable;
          List<Location> locations = List<Location>.from(locationResponse.map<Location>((dynamic i) => Location.fromJson(i as Map<String, dynamic>)));
          return locations;
        }
      }
      return [];
    } catch (e){
      print(e);
      return [];
    }
  }
  
  Future<List<LocationForecast>> getForecastsWithinViewportBounds(LatLngBounds bounds) async {
    await validateToken();
    String lowLat = bounds.southwest.latitude.toString();
    String lowLon = bounds.southwest.longitude.toString();
    String uppLat = bounds.northeast.latitude.toString();
    String uppLon = bounds.northeast.longitude.toString();
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=bounds&lowLat=' + lowLat + '&lowLon=' + lowLon + '&uppLat=' + uppLat + '&uppLon=' + uppLon + '&access_token=' + token!.accessToken));
    if(response.body != "null" && response.statusCode == 200) {
      Iterable forecastsResponse  = json.decode(response.body) as Iterable;
      List<LocationForecast> locationForecast = List<LocationForecast>.from(forecastsResponse.map<LocationForecast>((dynamic i) => LocationForecast.fromJson(i as Map<String, dynamic>)));
      return locationForecast;
    }
    return [];
  }
  
  Future<LocationForecast?> getCurrentForecastForSpecificLocation(Location location) async {
    await validateToken();
    // 192.168.1.146:8080/api/forecast?method=coordinate&lat=59.91187031882089&lon=10.733528334101853&access_token=RUMEUXY2NZSM5IZX_GP85A&time=-1
    // http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=bounds&lowLat=' + lowLat + '&lowLon=' + lowLon + '&uppLat=' + uppLat + '&uppLon=' + uppLon + '&access_token=' + token!.accessToken));
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=coordinate&lat=' + location.geoJson.coordinates[0][1].toString() + '&lon=' + location.geoJson.coordinates[0][0].toString() + '&access_token=' + token!.accessToken));
    if(response.body != "null" && response.statusCode == 200) {
      
      Forecast forecast = Forecast.fromJson(json.decode(response.body));
      LocationForecast locationForecast = LocationForecast(
        name: location.name,
        alternativeNames: location.alternativeNames,
        geoJson: location.geoJson,
        forecast: forecast,
        importance: location.importance,
        locationType: location.locationType,
        municipality: location.municipality,
        county: location.county
      );
      return locationForecast;
    }
    return null;
  }
  /*
  Future<LocationForecast?> getAllForecastForSpecificCoordinates(LatLng location) async {
    await validateToken();
    // 192.168.1.146:8080/api/forecast?method=coordinate&lat=59.91187031882089&lon=10.733528334101853&access_token=RUMEUXY2NZSM5IZX_GP85A&time=-1
    // http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=bounds&lowLat=' + lowLat + '&lowLon=' + lowLon + '&uppLat=' + uppLat + '&uppLon=' + uppLon + '&access_token=' + token!.accessToken));
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=coordinate&time=-1&lat=' + location.latitude.toString() + '&lon=' + location.longitude.toString() + '&access_token=' + token!.accessToken));
    if(response.body != "null" && response.statusCode == 200) {
      Forecast forecast = Forecast.fromJson(json.decode(response.body));
      LocationForecast locationForecast = LocationForecast(
        name: "Min lokasjon",
        alternativeNames: [],
        coordinates: [Coordinates(latitude: location.latitude, longitude: location.longitude)],
        forecast: forecast,
        importance: 10,
        locationType: "Not implemented",
        municipality: "Not implemented",
        county: "Not implemented"
      );
      return locationForecast;
    }
    return null;
  }
  */
  
  Future<LocationForecast?> getAllForecastForSpecificLocation(Location location) async {
    await validateToken();
    // 192.168.1.146:8080/api/forecast?method=coordinate&lat=59.91187031882089&lon=10.733528334101853&access_token=RUMEUXY2NZSM5IZX_GP85A&time=-1
    // http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=bounds&lowLat=' + lowLat + '&lowLon=' + lowLon + '&uppLat=' + uppLat + '&uppLon=' + uppLon + '&access_token=' + token!.accessToken));
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=coordinate&time=-1&lat=' + location.geoJson.coordinates[0][1].toString() + '&lon=' + location.geoJson.coordinates[0][0].toString() + '&access_token=' + token!.accessToken));
    if(response.body != "null" && response.statusCode == 200) {
      Forecast forecast = Forecast.fromJson(json.decode(response.body));
      LocationForecast locationForecast = LocationForecast(
        name: location.name,
        alternativeNames: location.alternativeNames,
        geoJson: location.geoJson,
        forecast: forecast,
        importance: location.importance,
        locationType: location.locationType,
        municipality: location.municipality,
        county: location.county
      );
      return locationForecast;
    }
    return null;
  }
  
  Future<CalculatedRouteWithForecast?> getRouteBetweenLocations(List<Location> locations, TraficType traficType) async {
    await validateToken();
    // 192.168.1.146:8080/api/forecast?method=coordinate&lat=59.91187031882089&lon=10.733528334101853&access_token=RUMEUXY2NZSM5IZX_GP85A&time=-1
    // http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/forecast?method=bounds&lowLat=' + lowLat + '&lowLon=' + lowLon + '&uppLat=' + uppLat + '&uppLon=' + uppLon + '&access_token=' + token!.accessToken));
    Uri uri = Uri.parse('http://192.168.1.146:8080/api/route/?access_token=' + token!.accessToken + '&traficType=' + traficType.toShortString().toLowerCase());
    http.Response response = await http.post(
      uri, 
      body: json.encode({"locations": locations}),
    );
    if(response.body != "null" && response.statusCode == 200) { 
      return CalculatedRouteWithForecast.fromJson(json.decode(response.body));
    }
    return null;
  }
}