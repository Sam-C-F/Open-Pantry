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
                            hintText: "Search by postcode"),
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
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 15),
                  child: SelectableText(
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
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            height: 10,
                            thickness: 10,
                            color: Color(0xffFDF5E6),
                          ),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                                minVerticalPadding: 10.0,
                                horizontalTitleGap: 10.0,
                                contentPadding: EdgeInsets.all(10),
                                tileColor: Color(0xffFDF5E6),
                                title: SelectableText(users[index].name,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffFDF5E6))),
                                subtitle: SelectableText(users[index].postcode,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff4F4f4f))),
                                trailing: ElevatedButton(
                                    child: Text('GO'),
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
                ),
              )
            ])));
  }
}
