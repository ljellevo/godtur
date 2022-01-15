

import 'package:flutter/cupertino.dart';
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
}