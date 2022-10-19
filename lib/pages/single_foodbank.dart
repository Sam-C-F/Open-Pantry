import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FoodBank extends StatefulWidget {
  FoodBank(
      {Key? key,
      required this.passedName,
      required this.passedAddress,
      required this.passedLatLng,
      required this.passedUrls,
      required this.passedNeeds})
      : super(key: key);
  final String passedName;
  final String passedAddress;
  final String passedLatLng;
  final String passedUrls;
  final String passedNeeds;
  @override
  State<FoodBank> createState() => _MyWidgetState();
}

late GoogleMapController mapController;

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

// _fbLocation(passed) {
//   var fbLocStr = passed.split(",");
//   var lat = double.parse(fbLocStr[0]);
//   var lon = double.parse(fbLocStr[1]);
//   var latlon = [lat, lon];
//   return latlon;
// }

_fbLocation(passedLatLng) {
  var currentLocation = passedLatLng;
  var splitLocation = currentLocation.split(",");
  var lat = double.parse(splitLocation[0]);
  var lon = double.parse(splitLocation[1]);
  final LatLng returnLocation = LatLng(lat, lon);
  return returnLocation;
}

_url(passedUrls) {
  var splitUrl = passedUrls.split("//");
  print(splitUrl[1]);
  return splitUrl[1];
}

// class _FoodBankNeedsState extends State<FoodBank> {
//   final _saved = <String>{};
//   final _suggestions = <String>[];
//   void _pushSaved() {
//     Navigator.of(context).push((MaterialPageRoute<void>(builder: (context) {
//       final tiles = _saved.map((need) {
//         return ListTile(
//           title: Text(need),
//         );
//       });
//       final divided = tiles.isNotEmpty
//           ? ListTile.divideTiles(
//               context: context,
//               tiles: tiles,
//             ).toList()
//           : <Widget>[];
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('My Shopping List'),
//         ),
//         body: ListView(children: divided),
//       );
//     })));
//   }
// }

class _MyWidgetState extends State<FoodBank> {
  @override
  Widget build(BuildContext context) {
    final List<String> needsList = widget.passedNeeds.split('\n');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FoodBank',
        home: Scaffold(
            backgroundColor: Color(0xffFDF5E6),
            appBar: AppBar(
                backgroundColor: Color(0xffFDF5E6),
                title: Row(
                  children: [
                    Expanded(
                      child:
                          Image.asset('assets/images/grouplogo.png', scale: 2),
                    ),
                  ],
                ),
                leading: ElevatedButton(
                    child: Icon(Icons.home, color: Color(0xff79b465)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFDF5E6)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
            body: Column(children: [
              Container(
                  color: Color(0xFFFDF5E6),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(6),
                  child: Text(
                    '${widget.passedName}',
                    style: TextStyle(
                        fontFamily: 'Josefin',
                        color: Color(0xff79b465),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                  color: Color(0xFFFDF5E6),
                  child: SizedBox(
                    width: 1000.0,
                    height: 250.0,
                    child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: _fbLocation(widget.passedLatLng),
                            zoom: 15.0),
                        markers: Set<Marker>.of([
                          Marker(
                            markerId: MarkerId(widget.passedName),
                            position: _fbLocation(widget.passedLatLng),
                            infoWindow: InfoWindow(
                              title: widget.passedName,
                              snippet: widget.passedAddress,
                            ),
                          )
                        ])),
                  )),
              Container(
                color: Color(0xfffdf5e6),
                child: Row(children: [
                  Column(
                    children: [
                      Text(_url(widget.passedUrls),
                          style: TextStyle(
                              fontFamily: 'Josefin',
                              color: Color(0xff79b465),
                              fontSize: 25,
                              fontWeight: FontWeight.bold))
                    ],
                  )
                ]),
              ),
              Container(
                  color: Color(0xFFFDF5E6),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Current Requested Items',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Josefin',
                        color: Color(0xff79b465),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  child: ListView.separated(
                      itemCount: needsList.length,
                      separatorBuilder: (BuildContext context, index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          tileColor: Color.fromARGB(255, 126, 184, 107),
                          title: Text(needsList[index],
                              style: TextStyle(
                                color: Color(0xff4F4f4f),
                                fontWeight: FontWeight.bold,
                              )),
                        );
                      }))
            ])));
  }
}
