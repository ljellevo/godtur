

import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/CalculatedRouteWithForecast.dart';
import 'package:mcappen/Classes/RouteLinesAndBounds.dart';
import 'package:mcappen/Classes/Weather.dart';

class Utils {
  
  void setTextInTextField(TextEditingController controller, String text){
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.fromPosition(
        TextPosition(offset: text.length),
      ),
    );
  }
  
  bool isWithinCurrentHour(Weather weather) {
    double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    if(weather.time > timestamp - 3600 && weather.time <= timestamp) {
      return true;
    }
    return false;
  }
  
  
  String getFormattedDatefromDate(DateTime date) {
    String day = date.day.toString();
    String month = date.month.toString();
    String hour = date.hour.toString();
    String minute = date.minute.toString();
    month = month.length == 2 ? month : "0" + month;
    day = day.length == 2 ? day : "0" + day;
    hour = hour.length == 2 ? hour : "0" + hour;
    minute = minute.length == 2 ? minute : "0" + minute;
    
    return day + "/" + month;
  }
  
  List<List<Weather>> getFormattedDateArrayfromDate(List<Weather> weather) {
    List<List<Weather>> differentDays = [];
    List<Weather> weatherForAGivenDay = [];
    //print(" ");
    //print(" ----- ");
    for(var i = 0; i < weather.length; i++) {
      
      if(i - 1 >= 0) {
        int currentForecastDay = DateTime.fromMillisecondsSinceEpoch(weather[i].time * 1000).day;
        int previousForcastDay = DateTime.fromMillisecondsSinceEpoch(weather[i - 1].time * 1000).day;
        if(currentForecastDay == previousForcastDay) {
          //print("Add dynamic");
          //print(weather[i].airTemperature);
          weatherForAGivenDay.add(weather[i]);
        } else {
          //print("New day");
          //print(weather[i].airTemperature);
          differentDays.add(weatherForAGivenDay);
          weatherForAGivenDay = [];
          weatherForAGivenDay.add(weather[i]);
        }
      } else {
        //print("Add static");
        //print(weather[i].airTemperature);
        weatherForAGivenDay.add(weather[i]);
      }
    }
    return differentDays;
  }
  
  String getFormattedDateTimefromDate(DateTime date) {
    String month = date.month.toString();
    String day = date.day.toString();
    String hour = date.hour.toString();
    String minute = date.minute.toString();
    
    month = month.length == 2 ? month : "0" + month;
    day = day.length == 2 ? day : "0" + day;
    hour = hour.length == 2 ? hour : "0" + hour;
    minute = minute.length == 2 ? minute : "0" + minute;
    
    return day.toString() + "/" + month+ " " + hour.toString() + ":" + minute.toString();
  }
  
  String getFormattedTimefromDate(DateTime date) {
    String month = date.month.toString();
    String day = date.day.toString();
    String hour = date.hour.toString();
    String minute = date.minute.toString();
    
    month = month.length == 2 ? month : "0" + month;
    day = day.length == 2 ? day : "0" + day;
    hour = hour.length == 2 ? hour : "0" + hour;
    minute = minute.length == 2 ? minute : "0" + minute;
    
    return hour.toString() + ":" + minute.toString();
  }
  
  String getFormattedTimeRangefromDate(DateTime date) {
    int nextH = -1;
    if(date.hour + 1 == 24) {
      nextH = 0;
    } else {
      nextH = date.hour + 1;
    }
    
    String hour = date.hour.toString().length == 2 ? date.hour.toString() : "0" + date.hour.toString();
    String nextHour = nextH.toString().length == 2 ? nextH.toString() : "0" + nextH.toString();
    return hour.toString() + "-" + nextHour.toString();
  }
  
  RouteLinesAndBounds getBounds(CalculatedRouteWithForecast route) {
    RouteLinesAndBounds routeLinesAndBounds = RouteLinesAndBounds();
    
    double lowLat = 0.0;
    double lowLon = 0.0;
    double upLat = 0.0;
    double upLon = 0.0;
        
    for(var i = 0; i < route.directions.coordinates.length; i++) {
      LatLng currentCoord = LatLng(route.directions.coordinates[i][1], route.directions.coordinates[i][0]);
      routeLinesAndBounds.add(currentCoord);
      if(i == 0) {
        lowLat = currentCoord.latitude;
        upLat = currentCoord.latitude;
        lowLon = currentCoord.longitude;
        upLon = currentCoord.longitude;
        continue;
      }
      if(lowLat > currentCoord.latitude) {
        lowLat = currentCoord.latitude;
      }
      
      if(upLat < currentCoord.latitude) {
        upLat = currentCoord.latitude;
      }
      
      if(lowLon > currentCoord.longitude) {
        lowLon = currentCoord.longitude;
      }
      
      if(upLon < currentCoord.longitude) {
        upLon = currentCoord.longitude;
      }
      
      /*
      if(routeLinesAndBounds.getSouthwest() == null) {
        routeLinesAndBounds.setSouthwest(currentCoord);
      }
      
      if(routeLinesAndBounds.getNortheast() == null) {
        routeLinesAndBounds.setNortheast(currentCoord);
      }
      
      if(currentCoord.latitude < routeLinesAndBounds.getSouthwest()!.latitude && currentCoord.longitude < routeLinesAndBounds.getSouthwest()!.longitude) {
        routeLinesAndBounds.setSouthwest(currentCoord);
      } else if(currentCoord.latitude > routeLinesAndBounds.getNortheast()!.latitude && currentCoord.longitude > routeLinesAndBounds.getNortheast()!.longitude) {
        routeLinesAndBounds.setNortheast(currentCoord);
      }
      */
      
      
    }
    routeLinesAndBounds.setSouthwest(LatLng(lowLat, lowLon));
    routeLinesAndBounds.setNortheast(LatLng(upLat, upLon));
    
    return routeLinesAndBounds;
  }
}