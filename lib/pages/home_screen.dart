import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_pantry/api.dart';
import 'package:open_pantry/models/model.dart';

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
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffFDF5E6),
          title: Row(children: [
            Expanded(
              child: Image.asset('assets/images/grouplogo.png', scale: 2),
            ),
          ]),
        ),
        body: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(children: [
              Container(
                color: Color(0xffFDF5E6),
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                child: Row(
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
                            hintText: "Search by postcode..."),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ElevatedButton(
                              onPressed: () {
                                submitPostcode(userLocationInput, context);
                              },
                              child:
                                  Icon(Icons.search, color: Color(0xFFfdf5e6)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff79b465))),
                        ))
                  ],
                ),
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
                                      target: snapshot.requireData[0],
                                      zoom: 11.0),
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
                              padding: EdgeInsets.fromLTRB(0, 25, 0, 15),
                              child: Text(
                                'Your Local Foodbanks',
                                style: TextStyle(
                                    fontFamily: 'Staaliches',
                                    color: Color(0xff79b465),
                                    fontSize: 35,
                                    fontWeight: FontWeight.w900),
                              )),
                          Expanded(
                              child: Container(
                            color: Color(0xff79b465),
                            child: ListView.separated(
                                itemCount: users.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                          height: 10,
                                          thickness: 10,
                                          color: Color(0xffFDF5E6),
                                        ),
                                itemBuilder: (context, index) {
                                  return Column(
                                    key: Key('$index'),
                                    children: [
                                      ListTile(
                                        minVerticalPadding: 10.0,
                                        horizontalTitleGap: 10.0,
                                        contentPadding: EdgeInsets.all(10),
                                        tileColor: Color(0xffFDF5E6),
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
                                          child: Text('GO'),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff4F4f4f)),
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
                          )),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                        height: 500,
                        padding: EdgeInsets.all(75),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(25),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                  color: Colors.green),
                            ),
                            Container(
                              padding: EdgeInsets.all(25),
                              alignment: Alignment.center,
                              child: Text('Loading your local foodbanks...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Staaliches',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Color(0xff79b465))),
                            ),
                          ],
                        ));
                  }
                },
              ),
            ])));
  }
}
