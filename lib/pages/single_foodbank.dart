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


  _fbLocation(passedLatLng)  {
  var currentLocation = passedLatLng;
  var splitLocation = currentLocation.split(",");
  var lat = double.parse(splitLocation[0]);
  var lon = double.parse(splitLocation[1]);
  final LatLng returnLocation = LatLng(lat, lon);
  return returnLocation;
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
        title: 'FoodBank',
        home: Scaffold(
            backgroundColor: Color(0xffFDF5E6),
            appBar: AppBar(
                backgroundColor: Color(0xffFDF5E6),

                title: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset('assets/images/picwish.png'),
                    ),


                    Expanded(
                      flex: 4,
                      child: Text('${widget.passedName}',
                          style: TextStyle(
                              fontFamily: 'Josefin',
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff79b465))),
                    ),
                  ],
                ),
                leading: ElevatedButton(
                    child: Icon(Icons.arrow_back),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff79b465)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
            body: Column(children: [
              Row(children: [
                Container(
                  
                  child: Expanded(
                  // color:Color.fromARGB(255, 180, 240, 182),
                  // margin: const EdgeInsets.all(8),
                  // width: 2000.0,
                  child: Column(
                    children: [
                      Text('\n${widget.passedUrls}\n',
                          style: TextStyle(fontSize: 20)),
                      Text('${widget.passedAddress}',
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300, maxWidth: 300),
                  child: Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    
                    initialCameraPosition:
                        CameraPosition(target: _fbLocation(widget.passedLatLng)),
                  ),)

                )
              ]),
              Container(
                  color: Color(0xff79b465),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Needs',
                    style: TextStyle(
                        fontFamily: 'Josefin',
                        color: Color(0xFFFDF5E6),
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
