import 'dart:async';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/components/widgets/bottomNavigationCard.dart';
import 'package:app/components/widgets/locationSearchField.dart';
import 'package:app/models/autocomplete_prediction.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final loc.Location _locationController = loc.Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _currentP;
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = {};
  AutocompletePrediction? _selectedSource;
  AutocompletePrediction? _selectedDestination;
  bool _shouldFocusUserLocation = true;
  bool _mapInitialized = false;
  bool _trafficEnabled = true;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.bgColor,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8)
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _trafficEnabled ? Icons.traffic : Icons.traffic,
              color: _trafficEnabled ? AppTheme.lilacColor : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _trafficEnabled = !_trafficEnabled;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              if (_currentP != null) {
                _addCurrentLocationMarker();
                _cameraToPos(_currentP!);
              }
              setState(() {
                _mapInitialized = true;
              });
            },
            initialCameraPosition:
                CameraPosition(target: LatLng(0, 0), zoom: 13),
            markers: markers,
            polylines: Set<Polyline>.of(polylines.values),
            trafficEnabled: _trafficEnabled,
            onCameraMove: (CameraPosition position) {
              _shouldFocusUserLocation = false;
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
            child: LocationSearchWidget(
              onLocationSelected: (location) async {
                _selectedDestination = location;
                await _searchAndNavigate();
                setState(() {});
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation to different screens
        },
      ),
    );
  }

  Future<void> _cameraToPos(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((loc.LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (_mapInitialized && _shouldFocusUserLocation) {
            _cameraToPos(_currentP!);
          }
          _addCurrentLocationMarker();
        });
      }
    });
  }

  void _addCurrentLocationMarker() {
    if (_currentP != null) {
      markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: _currentP!,
        infoWindow: InfoWindow(title: 'Current Location'),
      ));
    }
  }

  Future<List<LatLng>> getPolylinePoints(
      LatLng source, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Variables.mapsAPIkey,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
      avoidFerries: false,
      avoidHighways: false,
      avoidTolls: false,
      optimizeWaypoints: true,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppTheme.lilacColor,
      points: polylineCoordinates,
      width: 3,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _searchAndNavigate() async {
    if (_currentP != null && _selectedDestination != null) {
      List<geo.Location> destinationLocations =
          await geo.locationFromAddress(_selectedDestination!.description!);

      if (destinationLocations.isNotEmpty) {
        LatLng destinationLatLng = LatLng(destinationLocations.first.latitude,
            destinationLocations.first.longitude);

        markers.add(Marker(
          markerId: MarkerId('destination'),
          position: destinationLatLng,
          infoWindow: InfoWindow(title: 'Destination'),
        ));

        List<LatLng> polylineCoordinates =
            await getPolylinePoints(_currentP!, destinationLatLng);
        generatePolylineFromPoints(polylineCoordinates);

        _cameraToPos(destinationLatLng);
      }
    }
  }
}
