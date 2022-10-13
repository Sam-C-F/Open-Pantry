import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_pantry/api.dart';
import 'package:open_pantry/models/model.dart';
import 'package:open_pantry/pages/single_foodbank.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var users = <User>[];

  _getUsers() {
    getLocation().then((currentLocation) {
      API.getUsersByLocation(currentLocation).then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          users = list.map((model) {
            return User.fromJson(model);
          }).toList();
        });
      });
    });
  }

  late GoogleMapController mapController;

  // _mapLocation() async {
  //   var currentLocation = await getLocation();
  //   var splitLocation = currentLocation.split(",");
  //   var lat = double.parse(splitLocation[0]);
  //   var lon = double.parse(splitLocation[1]);
  //   final LatLng returnLocation = LatLng(lat, lon);
  //   return returnLocation;
  // }

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

  getPostcode() {
    print(userLocationInput.text);
  }

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
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your postcode..."),
              ),
              ElevatedButton(
                onPressed: () {
                  getPostcode();
                },
                child: Text('Submit'),
              ),
            ],
          ),
          FutureBuilder<LatLng>(
            future: _mapLocation(),
            builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: snapshot.requireData, zoom: 11.0),
                  ),
                );
              } else {
                return Text('Loading...');
              }
            },
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

// Widget buildUsers(List<User> users) => ListView.builder(
//     itemCount: users.length,
//     itemBuilder: (context, index) {
//       final user = users[index];

//       return Card(
//         child: ListTile(
//           title: Text(user.name),
//           subtitle: Text(user.postcode),
//         ),
//       );
//     });
// @override
// Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         title: const Text("Open Pantry"),
//         centerTitle: true,
//       ),
//       body: Center(
//           child: FutureBuilder<List<User>>(
//               future: usersFuture,
//               builder: (context, snapshot) {
//                 print(snapshot.data);
//                 if (snapshot.hasData) {
//                   final users = snapshot.data!;
//                   return buildUsers(users);
//                 } else {
//                   return const Text("No user data");
//                 }
//               })),
//     );
