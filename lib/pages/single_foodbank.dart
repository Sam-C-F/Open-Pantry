import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodBank extends StatefulWidget {
  FoodBank(
      {Key? key,
      required this.passedName,
      required this.passedAddress,
      required this.passedLatLng,
      required this.passedUrls,
      required this.passedNeeds,
      required this.passedPhone})
      : super(key: key);
  final String passedName;
  final String passedAddress;
  final String passedLatLng;
  final String passedUrls;
  final String passedNeeds;
  final String passedPhone;
  @override
  State<FoodBank> createState() => _MyWidgetState();
}

late GoogleMapController mapController;

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

_fbLocation(passedLatLng) {
  var currentLocation = passedLatLng;
  var splitLocation = currentLocation.split(",");
  var lat = double.parse(splitLocation[0]);
  var lon = double.parse(splitLocation[1]);
  final LatLng returnLocation = LatLng(lat, lon);
  return returnLocation;
}

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
            body: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      color: Color(0xFFFDF5E6),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(6),
                      child: SelectableText(
                        '${widget.passedName}',
                        style: TextStyle(
                            fontFamily: 'Staaliches',
                            color: Color(0xff4F4f4f),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                      Expanded(
                          child: new RichText(
                        text: new TextSpan(
                            text: 'Click to visit website',
                            style: TextStyle(
                              fontFamily: 'Staaliches',
                              color: Color(0xff4F4f4f),
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                // ignore: deprecated_member_use
                                launch(widget.passedUrls);
                              }),
                      )),
                      Expanded(
                          child: SelectableText(widget.passedPhone,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Staaliches',
                                color: Color(0xff4F4f4f),
                                fontSize: 20,
                              )))
                    ]),
                  ),
                  Container(
                      color: Color(0xFFFDF5E6),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(25, 6, 6, 6),
                      margin: EdgeInsets.only(bottom: 4),
                      child: SelectableText(
                        'Current Requested Items',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Staaliches',
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
                              title: SelectableText(needsList[index],
                                  style: TextStyle(
                                    color: Color(0xff4F4f4f),
                                    fontWeight: FontWeight.bold,
                                  )),
                            );
                          }))
                ]))));
  }
}
