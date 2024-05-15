import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/widgets/appTheme.dart';

class TrafficIncident {
  final String description;
  final String title;
  final double latitude;
  final double longitude;
  final int severity;

  TrafficIncident({
    required this.description,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.severity,
  });

  factory TrafficIncident.fromJson(Map<String, dynamic> json) {
    final description = json['description'] ?? 'No description available';
    final title = json['title'] ?? 'No title';
    final latitude = json['point']['coordinates'][0];
    final longitude = json['point']['coordinates'][1];
    final severity = json['severity'] ?? 0;

    return TrafficIncident(
      description: description,
      title: title,
      latitude: latitude,
      longitude: longitude,
      severity: severity,
    );
  }
}

Future<List<TrafficIncident>> fetchTrafficIncidents() async {
  final url =
      'http://dev.virtualearth.net/REST/v1/Traffic/Incidents/23.6345,60.8728,37.0841,77.8375/?key=AllxjOXEteY0lXaDlpoROLvE5I7A1V0nvZTHoCljqPsCTFCP9KL6-BzokOYK_NH8';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final resources = jsonResponse['resourceSets'][0]['resources'];
    return resources
        .map<TrafficIncident>((json) => TrafficIncident.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load traffic incidents');
  }
}

class TrafficIncidentsScreen extends StatefulWidget {
  @override
  _TrafficIncidentsScreenState createState() => _TrafficIncidentsScreenState();
}

class _TrafficIncidentsScreenState extends State<TrafficIncidentsScreen> {
  late Future<List<TrafficIncident>> futureIncidents;
  List<TrafficIncident> filteredIncidents = [];
  int selectedSeverity = 0;

  @override
  void initState() {
    super.initState();
    futureIncidents = fetchTrafficIncidents();
    futureIncidents.then((incidents) {
      setState(() {
        filteredIncidents = incidents;
      });
    });
  }

  void filterIncidents(int severity) {
    setState(() {
      selectedSeverity = severity;
      if (severity == 0) {
        futureIncidents.then((incidents) {
          setState(() {
            filteredIncidents = incidents;
          });
        });
      } else {
        futureIncidents.then((incidents) {
          setState(() {
            filteredIncidents = incidents
                .where((incident) => incident.severity == severity)
                .toList();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title: Text('Traffic Incidents',
            style: TextStyle(color: AppTheme.lightGreyColor)),
        iconTheme: IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              value: selectedSeverity,
              dropdownColor: AppTheme.bgColor,
              onChanged: (int? newValue) {
                filterIncidents(newValue!);
              },
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('All',
                      style: TextStyle(color: AppTheme.lightGreyColor)),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('LowImpact',
                      style: TextStyle(color: AppTheme.lightGreyColor)),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Minor',
                      style: TextStyle(color: AppTheme.lightGreyColor)),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Moderate',
                      style: TextStyle(color: AppTheme.lightGreyColor)),
                ),
                DropdownMenuItem<int>(
                  value: 4,
                  child: Text('Serious',
                      style: TextStyle(color: AppTheme.lightGreyColor)),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TrafficIncident>>(
              future: futureIncidents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(color: AppTheme.lightGreyColor)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No traffic incidents found.',
                          style: TextStyle(color: AppTheme.lightGreyColor)));
                } else {
                  return ListView.builder(
                    itemCount: filteredIncidents.length,
                    itemBuilder: (context, index) {
                      return _buildTrafficIncidentItem(
                          filteredIncidents[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficIncidentItem(TrafficIncident incident) {
    return GestureDetector(
      onTap: () {
        // Handle incident item tap
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppTheme.greyColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            // BoxShadow(
            //   color: AppTheme.lightGreyColor,
            //   spreadRadius: 2,
            //   blurRadius: 5,
            //   offset: Offset(0, 3),
            // ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              incident.title,
              style: GoogleFonts.roboto(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppTheme.whiteColor,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              'Location: ${incident.latitude}, ${incident.longitude}',
              style: GoogleFonts.roboto(
                color: AppTheme.lightGreyColor,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              incident.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: AppTheme.lightGreyColor,
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.traffic, color: AppTheme.lightGreyColor),
                Text(
                  'Severity: ${incident.severity}',
                  style: GoogleFonts.roboto(
                    color: AppTheme.lightGreyColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
