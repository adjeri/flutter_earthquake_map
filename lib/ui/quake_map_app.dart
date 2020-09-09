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
  double _zoomVal = 5.0;

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
          _zoomMinus(),
          _zoomPlus(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            findQuakes();
          },
          label: Text("Find quakes")),
    );
  }

  Widget _zoomPlus(){
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: FaIcon(FontAwesomeIcons.searchPlus,color: Colors.black87,),
          onPressed: () {
            _zoomVal++;
            _plus(_zoomVal);
          },
        ),
      ),
    );
  }

  Widget _zoomMinus(){
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: FaIcon(FontAwesomeIcons.searchMinus,color: Colors.black87,),
          onPressed: () {
            _zoomVal--;
            _minus(_zoomVal);
          },
        ),
      ),
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
        markers: Set<Marker>.of(_markerList),
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
              infoWindow: InfoWindow(title: quake.properties.mag.toString(),snippet: quake.properties.title),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: LatLng(quake.geometry.coordinates[1].toDouble(),
                  quake.geometry.coordinates[0]),
              onTap: () {}),)
        })
      });
    });
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.17864,-74.484),zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.17864,-74.484),zoom: zoomVal)));
  }
}
