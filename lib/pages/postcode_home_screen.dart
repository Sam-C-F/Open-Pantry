import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_pantry/api.dart';
import 'package:open_pantry/models/model.dart';
import 'package:open_pantry/pages/single_foodbank.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

class PostcodeHomeScreen extends StatefulWidget {
  const PostcodeHomeScreen({
    Key? key,
    required this.postcodeDataForList,
    required this.postcodeLocationLatLng,
  }) : super(key: key);
  final LatLng postcodeLocationLatLng;
  final String postcodeDataForList;

  @override
  State<PostcodeHomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PostcodeHomeScreen> {
  var users = <User>[];

  _getUsers() {
    API.getUsersByLocation(widget.postcodeDataForList).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) {
          return User.fromJson(model);
        }).toList();
      });
    });
  }

  late GoogleMapController mapController;

  Future<LatLng> _mapLocation() async {
    var currentLocation = await getLocation();
    var splitLocation = currentLocation.split(",");
    var lat = double.parse(splitLocation[0]);
    var lon = double.parse(splitLocation[1]);
    final LatLng returnLocation = LatLng(lat, lon);
    return returnLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  var userLocationInput = TextEditingController();

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Available Foodbanks", style: TextStyle(fontSize: 50)),
          centerTitle: true,
        ),
        body: Column(children: [
          Column(
            children: [
              TextField(
                controller: userLocationInput,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your postcode..."),
              ),
              ElevatedButton(
                onPressed: () async {
                  var postcode = userLocationInput.text;
                  var url =
                      Uri.parse("https://api.postcodes.io/postcodes/$postcode");
                  var response = await http.get(url);
                  var data = jsonDecode(response.body);
                  var lat = data['result']['latitude'];
                  var lon = data['result']['longitude'];
                  final postcodeDataForList = ('$lat, $lon');
                  final LatLng postcodeLocationLatLng = LatLng(lat, lon);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostcodeHomeScreen(
                                postcodeLocationLatLng: postcodeLocationLatLng,
                                postcodeDataForList: postcodeDataForList,
                              )));
                },
                child: Text('Submit'),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: widget.postcodeLocationLatLng, zoom: 11.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(users[index].name),
                      subtitle: Text(users[index].postcode),
                      trailing: ElevatedButton(
                          child: const Text('Go'),
                          onPressed: () async {
                            String id = users[index].slug;
                            var url = Uri.parse(
                                'https://www.givefood.org.uk/api/2/foodbank/$id/');
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
                          }));
                }),
          )
        ]));
  }
}
