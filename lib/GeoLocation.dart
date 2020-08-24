import 'package:geolocator/geolocator.dart';

class GeoLocation {

  Future<Position> positionCheck() async{
    var position =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position==null){
      position =  await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    }
    return position;
  }

  Future<String> locationCheck({position : Position}) async{
    List<Placemark> placemarks = await Geolocator().placemarkFromPosition(position);
    if (placemarks!=null && !placemarks.isEmpty) {
      print('Latest Known Location is ${placemarks[0].locality}');
      return placemarks[0].locality;
    }
  }
}