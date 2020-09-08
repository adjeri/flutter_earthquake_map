import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowSimpleMap extends StatefulWidget {
  @override
  _ShowSimpleMapState createState() => _ShowSimpleMapState();
}

class _ShowSimpleMapState extends State<ShowSimpleMap> {
  GoogleMapController mapController;
  static LatLng _center = const LatLng(45.521563, -122.677433);
  static LatLng _anotherLocation = const LatLng(45.512457, -122.606607);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
      ),
      body: GoogleMap(
        markers: {portLandMarker, portLandMarker2},
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToIntel,
        label: Text("Intel Corp!"),
        icon: Icon(Icons.place),
      ),
    );
  }

  static final CameraPosition intelPosition =
      CameraPosition(target: LatLng(45.5409843, -122.9181995), zoom: 15,bearing:191.789, tilt: 34.89);

  Future<void> _goToIntel() async {
    final GoogleMapController controller = await mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(intelPosition));
  }

  Marker portLandMarker = Marker(
      markerId: MarkerId("Portland"),
      position: _center,
      infoWindow: InfoWindow(title: "Portland", snippet: "This is nice"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));
  Marker portLandMarker2 = Marker(
      markerId: MarkerId("MtTabor"),
      position: _anotherLocation,
      infoWindow:
          InfoWindow(title: "Mt. Tabor", snippet: "Nice view from here"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
}
