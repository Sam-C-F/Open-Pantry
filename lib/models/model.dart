import 'package:geolocator/geolocator.dart';

class User {
  String name, postcode, slug, latLng;

  User(this.name, this.postcode, this.slug, this.latLng);

  User.fromJson(Map json)
      : name = json['name'],
        postcode = json['postcode'],
        slug = json['slug'],
        latLng = json['lat_lng'];

  Map toJson() {
    return {
      'name': name,
      'postcode': postcode,
      'slug': slug,
      'latitude': latLng
    };
  }
}

getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  var currentLocation = ('${position.latitude},${position.longitude}');

  return currentLocation;
}
