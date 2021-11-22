import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class LocationService
{
  String city;
  Future getAddressFromLatLng(LocationData locationData) async
  {
    try
    {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude,
          locationData.longitude
      );
      Placemark place = placemarks[0];
      city = place.locality;
    }
    catch (e)
    {
      print(e);
    }
  }
}