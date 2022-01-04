
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/Forecast.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/Classes/Token.dart';

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
  
  Future<List<Location>> getLocationBySearch(String searchValue) async {
    await validateToken();
    http.Response response = await http.get(Uri.parse('http://192.168.1.146:8080/api/locations/search?name=' + searchValue + '&access_token=' + token!.accessToken));
    if(response.statusCode == 200) {
      if(response.body != "null") {
        Iterable locationResponse  = json.decode(response.body) as Iterable;
        List<Location> locations = List<Location>.from(locationResponse.map<Location>((dynamic i) => Location.fromJson(i as Map<String, dynamic>)));
        return locations;
      }
    }
    return [];
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
}