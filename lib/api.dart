import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://www.givefood.org.uk";

class API {
  static Future getUsersByLocation(location) async {
    var url = baseUrl + "/api/2/foodbanks/search/?lat_lng=${location}";
    var parsedUrl = Uri.parse(url);
    return http.get(parsedUrl);
  }
}
