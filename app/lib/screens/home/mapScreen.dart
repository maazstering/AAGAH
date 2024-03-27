import 'package:app/widgets/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => __MapScreenState();
}

class __MapScreenState extends State<MapScreen> {
  static const LatLng karachi = LatLng(25.10720314676199, 67.27599663525518);
  static const LatLng trial = LatLng(37.4223, -122.0848);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.bgColor,
          title: const Text("Map Screen"),
          titleTextStyle: const TextStyle(color: AppTheme.periwinkleColor),
        ),
        body: const GoogleMap(
          initialCameraPosition: CameraPosition(target: karachi, zoom: 13),
        ));
  }
}
