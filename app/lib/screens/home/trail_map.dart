import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  
  static const cityCampus = LatLng(24.867838236805532, 67.02584010369931);
  static const mainCampus = LatLng(24.942530017375045, 67.11440558835665);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(target: mainCampus, zoom: 13)),
    );
  }
}
