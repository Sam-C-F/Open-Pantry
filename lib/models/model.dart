import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_pantry/pages/single_foodbank.dart';
import 'package:http/http.dart' as http;

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

toFoodBankPage(id, context) async {
  var url = Uri.parse('https://www.givefood.org.uk/api/2/foodbank/$id/');
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  String name = data['name'];
  String address = data['address'];
  String latLng = data['lat_lng'];
  String urls = data['urls']['homepage'];
  String needs = data['need']['needs'];

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FoodBank(
              passedName: name,
              passedAddress: address,
              passedLatLng: latLng,
              passedUrls: urls,
              passedNeeds: needs)));
}
