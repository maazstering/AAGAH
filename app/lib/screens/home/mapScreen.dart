import 'dart:async';
import 'dart:html';
import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => __MapScreenState();
}

class __MapScreenState extends State<MapScreen> {

  
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

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

  Future<void> _cameraToPos(LatLng pos) async{
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

  
   
}

