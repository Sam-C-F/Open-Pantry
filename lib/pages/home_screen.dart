import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_pantry/api.dart';
import 'package:open_pantry/models/model.dart';
import 'package:open_pantry/main.dart';

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
        backgroundColor: Color(0xffFDF5E6),
        appBar: AppBar(
          backgroundColor: Color(0xffFDF5E6),
          title: Container(
            child: 
            Image.asset('assets/images/grouplogo.png',  scale: 2)),
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
                                key: Key('$index'),
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
                                        },
                                        ),
                                                ),
                              
                                  SizedBox(height: 5)
                                ],
                              );
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
