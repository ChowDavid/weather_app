import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/Constant.dart';

class Weather {
  var temp;
  var desc;
  var iconUrl;
  var sunRise;
  var sunSet;

  Future<void> getWeather({lat: double, lon: double}) async{
    var url = 'https://api.openweathermap.org/data/2.5/weather?units=metric&lat=$lat&lon=$lon&APPID=$Constant.WEATHER_APP_ID';
    print('url $url');
    var response = await http.get(url);
    if (response.statusCode==200){
      var weather = jsonDecode(response.body);
      print('Temp ${weather['main']['temp']}');
      this.temp = weather['main']['temp'].toString();
      this.desc = weather['weather'][0]['description'];
      var icon = weather['weather'][0]['icon'];
      this.iconUrl = 'http://openweathermap.org/img/wn/$icon@2x.png';

      this.sunRise = DateTime.fromMillisecondsSinceEpoch(weather['sys']['sunrise']*1000,isUtc: false);
      this.sunSet = DateTime.fromMillisecondsSinceEpoch(weather['sys']['sunset']*1000,isUtc: false);
      print('SunRise ${weather['sys']['sunrise']}, SunSet ${weather['sys']['sunset']}');
    }

  }
}