import 'dart:convert';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/screens/news/locationSearch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:google_places_flutter/model/prediction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Info',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppTheme.lilacColor,
        scaffoldBackgroundColor: AppTheme.bgColor,
        appBarTheme: const AppBarTheme(
          color: AppTheme.bgColor,
          iconTheme: IconThemeData(color: AppTheme.lightGreyColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.lilacColor),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppTheme.lightGreyColor),
          bodyMedium: TextStyle(color: AppTheme.lightGreyColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: AppTheme.greyColor),
          filled: true,
          fillColor: AppTheme.mediumGreyColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: TrafficInfoScreen(),
    );
  }
}

class TrafficInfoScreen extends StatefulWidget {
  @override
  _TrafficInfoScreenState createState() => _TrafficInfoScreenState();
}

class _TrafficInfoScreenState extends State<TrafficInfoScreen> {
  final String apiKey = Variables.mapsAPIkey;
  Prediction? startPrediction;
  Prediction? endPrediction;
  List<Map<String, dynamic>> detailedSteps = [];
  String errorMessage = '';

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  Future<void> getTrafficInfo() async {
    if (startPrediction == null || endPrediction == null) {
      setState(() {
        errorMessage = 'Please select both start and end locations';
      });
      return;
    }

    try {
      // Get coordinates for start and end addresses
      final startLatLng = await _getCoordinates(startPrediction!.placeId!);
      final endLatLng = await _getCoordinates(endPrediction!.placeId!);

      // Get directions with traffic info
      final directionsUrl =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${startLatLng['lat']},${startLatLng['lng']}&destination=${endLatLng['lat']},${endLatLng['lng']}&departure_time=now&key=$apiKey';
      final response = await http.get(Uri.parse(directionsUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final legs = route['legs'][0];

          setState(() {
            detailedSteps = _parseSteps(legs['steps']);
            errorMessage = ''; // Clear error message
          });
        } else {
          setState(() {
            errorMessage = 'Error fetching traffic data: ${data['status']}';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching traffic data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Exception: ${e.toString()}';
      });
    }
  }

  Future<Map<String, dynamic>> _getCoordinates(String placeId) async {
    final geocodeUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey';
    final response = await http.get(Uri.parse(geocodeUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        return {'lat': location['lat'], 'lng': location['lng']};
      } else {
        throw Exception('Error fetching location data: ${data['status']}');
      }
    } else {
      throw Exception('Error fetching location data');
    }
  }

  List<Map<String, dynamic>> _parseSteps(List<dynamic> steps) {
    final List<Map<String, dynamic>> parsedSteps = [];
    const double averageSpeedKmh = 40;

    for (var step in steps) {
      final instruction = step['html_instructions'];
      final distanceStep = step['distance']['text'];
      final distanceKm = double.parse(distanceStep.split(" ")[0]);
      final expectedDurationHours = distanceKm / averageSpeedKmh;
      final expectedDurationSeconds = expectedDurationHours * 3600;

      final soup = parse(instruction);
      final roadNameTags = soup.querySelectorAll('b');
      String roadName =
          roadNameTags.isNotEmpty ? roadNameTags.last.text : 'Unknown road';

      if (['left', 'right', 'straight'].contains(roadName.toLowerCase())) {
        roadName = 'Unknown road';
      }

      final durationInTrafficStepSeconds =
          step['duration_in_traffic']?['value'] ?? step['duration']['value'];

      if (durationInTrafficStepSeconds > expectedDurationSeconds + 60) {
        parsedSteps.add({
          'road_name': roadName,
          'expected_duration_mins':
              (expectedDurationSeconds / 60).roundToDouble(),
          'duration_with_traffic_mins':
              (durationInTrafficStepSeconds / 60).roundToDouble(),
        });
      }
    }

    return parsedSteps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LocationSearchField(
              controller: startController,
              hintText: 'Start Address',
              onLocationSelected: (prediction) {
                setState(() {
                  startPrediction = prediction;
                  startController.text = prediction.description!;
                });
              },
            ),
            const SizedBox(height: 16),
            LocationSearchField(
              controller: endController,
              hintText: 'End Address',
              onLocationSelected: (prediction) {
                setState(() {
                  endPrediction = prediction;
                  endController.text = prediction.description!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getTrafficInfo,
              child: const Text('Get Traffic Info'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: detailedSteps.length,
                itemBuilder: (context, index) {
                  final step = detailedSteps[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppTheme.greyColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['road_name'],
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppTheme.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Expected: ${step['expected_duration_mins']} mins, With Traffic: ${step['duration_with_traffic_mins']} mins',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: AppTheme.lightGreyColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
