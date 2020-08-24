import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'GeoLocation.dart';
import 'Weather.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {


  var cityName;
  var temp;
  Position position;
  var desc;
  Image weatherIcon;
  Image weatherHead;
  DateTime lastVisit;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    cityName = 'Please wait...';
    temp = 'nil';
    weatherHead = displayImage();
    backendCheck().then((value) => setState(() {
    }));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  }


  @override
  Widget build(BuildContext context) {


    return  MaterialApp(
      home:  Scaffold(
        appBar: AppBar(
          title: Text('My Weather App'),
        ),
        body:  SafeArea(
          child:  Column(
            children: [
              Container(
                child: this.weatherHead,
              ),
              Container(
                margin: EdgeInsets.only(top:50),
                child : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You are in:',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                    ),),
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Text(this.cityName, style:
                      TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[500]
                      )),
                    SizedBox(width: 10,),
                    Icon(Icons.location_on,
                    color: Colors.red,)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 17),
                child: Card(

                  color: Colors.white,
                  child: ListTile(
                    leading: weatherIcon,
                    title: Text('Temperature: $temp C'),
                    subtitle: Text('$desc'),
                    onTap: () {backendCheck().then((value) => setState(() {}));}

                  ),
                )
              ),
            ],
          )
        )
      )
    );
  }


  Image displayImage() {
    var now = DateTime.now();
    final currentTime = DateFormat.jm().format(now);
    return currentTime.endsWith('AM')?Image.asset('images/dayTime.jpg'):Image.asset('images/nightTime.jpg');
  }

  Future<void> backendCheck() async{
    if (lastVisit!=null && lastVisit.add(Duration(seconds: 1)).isAfter(DateTime.now())) {
      print('lastUpdate $lastVisit, now ${DateTime.now()}');
      return;
    }
    lastVisit = DateTime.now();
    var location = GeoLocation();
    this.position = await location.positionCheck();
    this.cityName = await location.locationCheck(position: this.position);
    var weather = Weather();
    await weather.getWeather(lat:this.position.latitude,lon:this.position.longitude);
    this.temp = weather.temp;
    this.desc = weather.desc;
    this.weatherIcon = await Image.network(weather.iconUrl);

    var now = DateTime.now();
    if (now.isAfter(weather.sunRise) && now.isBefore(weather.sunSet)){
      this.weatherHead = Image.asset('images/dayTime.jpg');
    } else {
      print('night');
      this.weatherHead = Image.asset('images/nightTime.jpg');
    }
    print('day now ${now}, SunRise ${weather.sunRise}, SunSet ${weather.sunSet}');
  }







}

