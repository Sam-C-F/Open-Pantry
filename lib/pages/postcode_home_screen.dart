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
        backgroundColor: Color(0xffFDF5E6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffFDF5E6),
          title: Row(children: [
            Expanded(flex: 1, child: Image.asset('assets/images/picwish.png')),
            Expanded(
              flex: 4,
              child: Text("Open Pantry",
                  style: TextStyle(
                      fontFamily: 'Josefin',
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Color(0xff79b465))),
            )
          ]),
        ),
        body: Column(children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: userLocationInput,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xffFFFFFF),
                      border: OutlineInputBorder(),
                      hintText: "Enter your postcode..."),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () {
                      submitPostcode(userLocationInput, context);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Color(0xffFDF5E6), fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff79b465))),
              )
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
          Container(
              color: Color(0xFFFDF5E6),
              alignment: Alignment.center,
              padding: EdgeInsets.all(6),
              child: Text(
                'Your Local Foodbanks',
                style: TextStyle(
                    fontFamily: 'Josefin',
                    color: Color(0xff79b465),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                          minVerticalPadding: 10.0,
                          horizontalTitleGap: 10.0,
                          contentPadding: EdgeInsets.all(10),
                          tileColor: Color(0xff79b465),
                          title: Text(users[index].name,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffFDF5E6))),
                          subtitle: Text(users[index].postcode,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff4F4f4f))),
                          trailing: ElevatedButton(
                              child: const Icon(Icons.arrow_forward),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff4F4f4f)),
                              onPressed: () async {
                                String id = users[index].slug;
                                toFoodBankPage(id, context);
                              })),
                      SizedBox(height: 5)
                    ],
                  );
                }),
          )
        ]));
  }
}
