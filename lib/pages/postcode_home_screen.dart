import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_pantry/api.dart';
import 'package:open_pantry/models/model.dart';

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
                onPressed: () {
                  submitPostcode(userLocationInput, context);
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
                }))),
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
                            toFoodBankPage(id, context);
                          }));
                }),
          )
        ]));
  }
}
