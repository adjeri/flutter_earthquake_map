import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/model/quake.dart';
import 'package:flutter_map/network/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QuakesApp extends StatefulWidget {
  @override
  _QuakesAppState createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {
  Future<Quake> _quakesData;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markerList = <Marker>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quakesData = Network().getAllQuakes();
    _quakesData.then(
            (values) =>
        {
          print("Place: ${values.features[0].properties.place}")
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGoogleMap(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            findQuakes();
          },
          label: Text("Find quakes")),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition:
        CameraPosition(target: LatLng(36.1083331, -117.8608333), zoom: 3),
      ),
    );
  }

  void findQuakes() {
    setState(() {
      _markerList.clear();
      _handleResponse();
    });
  }

  void _handleResponse() {
    setState(() {
      _quakesData.then((quakes) =>
      {
        quakes.features.forEach((quake) =>
        {
          _markerList.add(Marker(markerId: MarkerId(quake.id),
              infoWindow: InfoWindow(title: quake.properties.mag.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: LatLng(quake.geometry.coordinates[1].toDouble(),
                  quake.geometry.coordinates[0]),
              onTap: () {}),)
        })
      });
    });
  }
}
