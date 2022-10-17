import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_pantry/api.dart';
import 'package:open_pantry/models/model.dart';
import 'package:open_pantry/pages/postcode_home_screen.dart';
import 'package:open_pantry/pages/single_foodbank.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = <User>[];

  Future<List> _getUsers() async {
    var currentLocation = await getLocation();
    var response = await API.getUsersByLocation(currentLocation);
    Iterable list = json.decode(response.body);
    return users = list.map((model) {
      return User.fromJson(model);
    }).toList();
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

  @override
  initState() {
    super.initState();
  }

  @override
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
          FutureBuilder<List>(
            future: Future.wait([
              _mapLocation(),
              _getUsers(),
            ]),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                  target: snapshot.requireData[0], zoom: 11.0),
                              markers: Set<Marker>.of(users.map((user) {
                                var splitLocation = user.latLng.split(",");
                                var lat = double.parse(splitLocation[0]);
                                var lon = double.parse(splitLocation[1]);
                                var foodBankLatLng = LatLng(lat, lon);
                                return Marker(
                                  markerId: MarkerId(user.name),
                                  position: foodBankLatLng,
                                  infoWindow: InfoWindow(
                                      title: user.name,
                                      snippet: user.postcode,
                                      onTap: () {
                                        toFoodBankPage(user.slug, context);
                                      }),
                                );
                              })))),
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
                                        toFoodBankPage(id, context);
                                      }));
                            }),
                      )
                    ],
                  ),
                );
              } else {
                return Text('Loading...');
              }
            },
          ),
        ]));
  }
}
