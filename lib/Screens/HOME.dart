import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skynavigator/Screens/FlightInfoScreen.dart';

import 'package:skynavigator/models/allState.dart';
import 'package:skynavigator/service/skyService.dart';
import 'dart:ui' as ui;

class HOME extends StatefulWidget {
  const HOME({super.key});

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  late GoogleMapController _mapController;
  String countryName = "United States";
  LatLng sw = LatLng(24.9493, -125.0011);
  LatLng ne = LatLng(49.5904, -66.9326);
  List<ALLState> allState = [];

  BitmapDescriptor? localpin;
  Set<Marker> markers = {};
  late Timer timer;
  int retryDelay = 15;

  List<BoundingCountryBox> boundingList = [
    BoundingCountryBox(
      sw: LatLng(24.396308, -125.0),
      ne: LatLng(49.384358, -66.93457),
      id: "USA",
      name: 'United States',
    ),
    BoundingCountryBox(
      sw: LatLng(18.166, 73.499),
      ne: LatLng(53.558, 135.084),
      id: "CHN",
      name: 'China',
    ),
    BoundingCountryBox(
      sw: LatLng(51.3, -10.5),
      ne: LatLng(55.4, -5.0),
      id: "IRL",
      name: 'Ireland',
    ),
    BoundingCountryBox(
      sw: LatLng(23.6345, 60.8728),
      ne: LatLng(37.0841, 77.0369),
      id: "PK",
      name: 'Pakistan',
    ),
    BoundingCountryBox(
      sw: LatLng(49.9, -6.3),
      ne: LatLng(60.8, 1.8),
      id: "GBR",
      name: 'United Kingdom',
    ),
    BoundingCountryBox(
      sw: LatLng(8.4, 68.7),
      ne: LatLng(37.6, 97.4),
      id: "IND",
      name: 'India',
    ),
    BoundingCountryBox(
      sw: LatLng(24.396308, 122.93457),
      ne: LatLng(45.551483, 153.986672),
      id: "JPN",
      name: 'Japan',
    ),
    BoundingCountryBox(
      sw: LatLng(47.3, 5.9),
      ne: LatLng(55.1, 15.0),
      id: "DEU",
      name: 'Germany',
    ),
    BoundingCountryBox(
      sw: LatLng(36.0, -9.5),
      ne: LatLng(43.8, 3.3),
      id: "ESP",
      name: 'Spain',
    ),
    BoundingCountryBox(
      sw: LatLng(5.6, 97.4),
      ne: LatLng(20.5, 105.6),
      id: "THA",
      name: 'Thailand',
    ),
  ];

  @override
  void initState() {
    super.initState();
    setCustomMapPIN();
    timer = Timer.periodic(Duration(seconds: 15), (timer) async {
      allState = await SkyNavigator().getAllStateBounds(sw, ne);
      setState(() {
        creaTeMarkeR();
      });
    });
  }

  Future<BitmapDescriptor> getIconMarkerFromIconData(
      IconData iconData, Color color, double size) async {
    // Create a PictureRecorder to record the icon being drawn
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    // final Paint paint = Paint()..color = color;
    final double iconSize = size;

    // Create a TextPainter to draw the icon
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: iconData.fontFamily,
        color: color,
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(0, 0));

    // Convert the canvas to an image and then to bytes
    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(iconSize.toInt(), iconSize.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(pngBytes);
  }

  void setCustomMapPIN() async {
    localpin = await getIconMarkerFromIconData(
      Icons.airplanemode_active, // The icon you want to use
      Colors.orange, // Color of the icon
      30, // Size of the icon in pixels
    );
    setState(() {}); // Ensure the state is updated after loading the image
  }

  Map<String, List<ALLState>> cachedData = {};

  void handleSelected() async {
    if (cachedData.containsKey(countryName)) {
      allState = cachedData[countryName]!;
      doSeTtate();
    } else {
      try {
        allState = await SkyNavigator().getAllStateBounds(sw, ne);
        cachedData[countryName] = allState;
        doSeTtate();
      } catch (e) {
        if (e.toString().contains("Rate limit exceeded")) {
          print("Rate limit exceeded. Retrying after $retryDelay seconds...");
          await Future.delayed(Duration(seconds: retryDelay));
          retryDelay *= 2; // Exponential backoff
          handleSelected(); // Retry
        } else {
          print("Error: $e");
        }
      }
    }
  }

  void doSeTtate() {
    setState(() {
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: sw, northeast: ne), 5));
      creaTeMarkeR();
    });
  }

  void creaTeMarkeR() {
    markers.clear();
    int markerLimit = 100;
    int count = 0;

    allState.forEach((state) {
      if (state.latitude != null &&
          state.longitude != null &&
          count < markerLimit) {
        LatLng _position = LatLng(state.latitude!, state.longitude!);
        markers.add(
          Marker(
            markerId: MarkerId(_position.toString()),
            position: _position,
            icon: localpin ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: state.callsign.trim(),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FlightInfoScreen(
                             
                                info: state,
                              )));
                },
                snippet:
                    'Origin country: ${state.originCountry}\n Velocity: ${state.velocity} \n Geom. alt: ${state.geoAltituce}\n Barom. alt: ${state.baroAltitude}'),
          ),
        );
        count++;
      }
    });
    print('Total markers added: ${markers.length}');
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    allState = await SkyNavigator().getAllStateBounds(sw, ne);
    print('AllState list: $allState');
    doSeTtate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: Stack(
          children: [
            SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sky Navigator".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.orange),
                      ),
                      Text(
                        "Real-time flight".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.orange),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Select country",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            items: boundingList.map((box) {
                              return DropdownMenuItem(
                                child: Text(box.name),
                                value: box.id,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                boundingList.forEach((element) {
                                  if (element.id == value) {
                                    sw = element.sw;
                                    ne = element.ne;
                                    countryName = element.name;
                                  }
                                });
                              });
                              handleSelected();
                            }),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Air Traffic over $countryName".toUpperCase(),
                          style: TextStyle(
                              color: Colors.orange[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Total flights ${allState.length}".toUpperCase(),
                          style: TextStyle(color: Colors.orange[900]),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 500,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      child: GoogleMap(
                        onMapCreated: onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(sw.latitude, ne.longitude), zoom: 2),
                        mapType: MapType.satellite,
                        markers: markers,
                      ),
                    ),
                  ),
                )
              ],
            ))
          ],
        ));
  }
}

class BoundingCountryBox {
  final String id;
  final String name;
  final LatLng sw;
  final LatLng ne;
  BoundingCountryBox({
    this.id = '',
    this.name = '',
    required this.sw,
    required this.ne,
  });
}
