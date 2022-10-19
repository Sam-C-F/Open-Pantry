import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_pantry/pages/single_foodbank.dart';
import 'package:http/http.dart' as http;
import '../pages/postcode_home_screen.dart';

class User {
  String name, postcode, slug, latLng, phone;

  User(this.name, this.postcode, this.slug, this.latLng, this.phone);

  User.fromJson(Map json)
      : name = json['name'],
        postcode = json['postcode'],
        slug = json['slug'],
        latLng = json['lat_lng'],
        phone = json['phone'];

  Map toJson() {
    return {
      'name': name,
      'postcode': postcode,
      'slug': slug,
      'latitude': latLng,
      'phone': phone,
    };
  }
}

getLocation() async {
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  await Geolocator.checkPermission();
  if (isLocationServiceEnabled == false) {
    await Geolocator.requestPermission();
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  var currentLocation = ('${position.latitude},${position.longitude}');

  return currentLocation;
}

toFoodBankPage(id, context) async {
  var url = Uri.parse('https://www.givefood.org.uk/api/2/foodbank/$id/');
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  String name = data['name'];
  String address = data['address'];
  String latLng = data['lat_lng'];
  String urls = data['urls']['homepage'];
  String needs = data['need']['needs'];
  String phone = data['phone'];

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FoodBank(
              passedName: name,
              passedAddress: address,
              passedLatLng: latLng,
              passedUrls: urls,
              passedNeeds: needs,
              passedPhone: phone)));
}

submitPostcode(userLocationInput, context) async {
  var postcode = userLocationInput.text;
  var url = Uri.parse("https://api.postcodes.io/postcodes/$postcode");
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  var lat = data['result']['latitude'];
  var lon = data['result']['longitude'];
  final postcodeDataForList = ('$lat, $lon');
  final LatLng postcodeLocationLatLng = LatLng(lat, lon);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostcodeHomeScreen(
                postcodeLocationLatLng: postcodeLocationLatLng,
                postcodeDataForList: postcodeDataForList,
              )));
}
