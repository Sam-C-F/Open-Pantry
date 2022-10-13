// class User {
//   final String name;
//   final String district;

//   const User({
//     required this.name,
//     required this.district,
//   });

//   static User fromJson(json) => User(
//         name: json["name"],
//         district: json["politics"]["district"],
//       );
// }
import 'package:geolocator/geolocator.dart';

class User {
  String name, postcode, slug;

  User(this.name, this.postcode, this.slug);

  User.fromJson(Map json)
      : name = json['name'],
        postcode = json['postcode'],
        slug = json['slug'];

  Map toJson() {
    return {'name': name, 'postcode': postcode, 'slug': slug};
  }
}

getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  var currentLocation = ('${position.latitude},${position.longitude}');

  return currentLocation;
}
