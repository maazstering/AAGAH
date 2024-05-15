import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class TrafficIncident {
  final String description;
  final String title;
  final double latitude;
  final double longitude;

  TrafficIncident({
    required this.description,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory TrafficIncident.fromXml(XmlElement element) {
    final description = element.findElements('Description').single.text;
    final title = element.findElements('Title').single.text;
    final latitude = double.parse(element
        .findElements('Point')
        .single
        .findElements('Latitude')
        .single
        .text);
    final longitude = double.parse(element
        .findElements('Point')
        .single
        .findElements('Longitude')
        .single
        .text);

    return TrafficIncident(
      description: description,
      title: title,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

Future<List<TrafficIncident>> fetchTrafficIncidents() async {
  final url =
      'http://dev.virtualearth.net/REST/v1/Traffic/Incidents/23.6345,60.8728,37.0841,77.8375/?key=YourAPIKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final document = XmlDocument.parse(response.body);
    final incidents = document.findAllElements('TrafficIncident');
    return incidents.map((e) => TrafficIncident.fromXml(e)).toList();
  } else {
    throw Exception('Failed to load traffic incidents');
  }
}
