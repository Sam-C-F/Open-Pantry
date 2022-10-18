import 'dart:async';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://www.givefood.org.uk";

class API {
  static Future getUsersByLocation(location) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    var url = baseUrl + "/api/2/foodbanks/search/?lat_lng=${location}";
    var parsedUrl = Uri.parse(url);
    return http.get(parsedUrl);
  }
}
