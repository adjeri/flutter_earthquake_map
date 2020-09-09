import 'package:flutter/material.dart';
import 'package:flutter_map/model/quake.dart';
import 'package:flutter_map/network/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuakesApp extends StatefulWidget {
  @override
  _QuakesAppState createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {
  Future<Quake> _quakesData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quakesData = Network().getAllQuakes();
    _quakesData.then((values) => {
      print("Place: ${values.features[0].properties.place}")
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
