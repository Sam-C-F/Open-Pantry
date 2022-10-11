import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://www.givefood.org.uk";

class API {
  static Future getUsers() {
    var url = baseUrl + "/api/2/foodbanks/";
    var parsedUrl = Uri.parse(url);
    return http.get(parsedUrl);
  }
}
