import 'dart:async';
import 'dart:html';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => __MapScreenState();
}

class __MapScreenState extends State<MapScreen> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const cityCampus = LatLng(24.867838236805532, 67.02584010369931);
  static const mainCampus = LatLng(24.942296541060056, 67.11431975767132);

  //static const LatLng karachi = LatLng(25.10720314676199, 67.27599663525518);
  //static const LatLng trial = LatLng(37.4223, -122.0848);
  LatLng? _currentP = null;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.bgColor,
          title: const Text("Map Screen"),
          titleTextStyle: const TextStyle(color: AppTheme.periwinkleColor),
        ),
        body: _currentP == null
            ? const Center(child: Text("Loading..."))
            : GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition:
                    CameraPosition(target: _currentP!, zoom: 13),
                markers: {
                  Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentP!),
                },
              ));
  }

  Future<void> _cameraToPos(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print(_currentP);
      }
    });
  }

  Future<List<LatLng>> getpolylinePoints() async {
    List<LatLng> polylinecoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Variables.mapsAPIkey,
        PointLatLng(mainCampus.latitude, mainCampus.longitude),
        PointLatLng(cityCampus.latitude, cityCampus.longitude),
        travelMode: TravelMode.driving,
        avoidFerries: false,
        avoidHighways: false,
        avoidTolls: false,
        optimizeWaypoints: true);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylinecoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    else{
      print (result.errorMessage);
    }

    return polylinecoordinates;
  }
}
