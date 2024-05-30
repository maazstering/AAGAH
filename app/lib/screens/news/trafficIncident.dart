import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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

Future<List<TrafficIncident>> fetchTrafficIncidents(
    {int? severity, List<int>? types}) async {
  String typeParam = types != null ? '&type=${types.join(",")}' : '';
  String severityParam = severity != null ? '&severity=$severity' : '';

  final url =
      'http://dev.virtualearth.net/REST/v1/Traffic/Incidents/23.6345,60.8728,37.0841,77.8375/?key=AllxjOXEteY0lXaDlpoROLvE5I7A1V0nvZTHoCljqPsCTFCP9KL6-BzokOYK_NH8$typeParam$severityParam';
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
  const TrafficIncidentsScreen({super.key});

  @override
  _TrafficIncidentsScreenState createState() => _TrafficIncidentsScreenState();
}

class _TrafficIncidentsScreenState extends State<TrafficIncidentsScreen> {
  late Future<List<TrafficIncident>> futureIncidents;
  List<TrafficIncident> filteredIncidents = [];
  int selectedSeverity = 0;
  List<int> selectedTypes = [];

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

  void filterIncidents(int severity, List<int> types) {
    setState(() {
      selectedSeverity = severity;
      selectedTypes = types;
      futureIncidents = fetchTrafficIncidents(
          severity: severity == 0 ? null : severity,
          types: types.isEmpty ? null : types);
      futureIncidents.then((incidents) {
        setState(() {
          filteredIncidents = incidents;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title: const Text('Traffic Incidents',
            style: TextStyle(color: AppTheme.lightGreyColor)),
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButton<int>(
                  value: selectedSeverity,
                  dropdownColor: AppTheme.bgColor,
                  onChanged: (int? newValue) {
                    filterIncidents(newValue!, selectedTypes);
                  },
                  items: const [
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text('All Severities',
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
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('Accident'),
                      selected: selectedTypes.contains(1),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(1);
                          } else {
                            selectedTypes.remove(1);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Congestion'),
                      selected: selectedTypes.contains(2),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(2);
                          } else {
                            selectedTypes.remove(2);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('DisabledVehicle'),
                      selected: selectedTypes.contains(3),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(3);
                          } else {
                            selectedTypes.remove(3);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('MassTransit'),
                      selected: selectedTypes.contains(4),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(4);
                          } else {
                            selectedTypes.remove(4);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Miscellaneous'),
                      selected: selectedTypes.contains(5),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(5);
                          } else {
                            selectedTypes.remove(5);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('OtherNews'),
                      selected: selectedTypes.contains(6),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(6);
                          } else {
                            selectedTypes.remove(6);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('PlannedEvent'),
                      selected: selectedTypes.contains(7),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(7);
                          } else {
                            selectedTypes.remove(7);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('RoadHazard'),
                      selected: selectedTypes.contains(8),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(8);
                          } else {
                            selectedTypes.remove(8);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Construction'),
                      selected: selectedTypes.contains(9),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(9);
                          } else {
                            selectedTypes.remove(9);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Alert'),
                      selected: selectedTypes.contains(10),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(10);
                          } else {
                            selectedTypes.remove(10);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Weather'),
                      selected: selectedTypes.contains(11),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(11);
                          } else {
                            selectedTypes.remove(11);
                          }
                          filterIncidents(selectedSeverity, selectedTypes);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TrafficIncident>>(
              future: futureIncidents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style:
                              const TextStyle(color: AppTheme.lightGreyColor)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
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
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppTheme.greyColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
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
            const SizedBox(height: 6.0),
            Text(
              'Location: ${incident.latitude}, ${incident.longitude}',
              style: GoogleFonts.roboto(
                color: AppTheme.lightGreyColor,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              incident.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: AppTheme.lightGreyColor,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.traffic, color: AppTheme.lightGreyColor),
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
