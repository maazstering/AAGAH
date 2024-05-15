import 'package:app/screens/home/trafficIncident.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // Dummy news data for demonstration
  List<Map<String, dynamic>> newsData = [
    {
      'title': 'Breaking News',
      'source': 'CNN',
      'image': '../assets/images/sample.jpg',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'title': 'Sports Update',
      'source': 'ESPN',
      'image': '../assets/images/sample.jpg',
      'description':
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    },
    {
      'title': 'Tech Insights',
      'source': 'TechCrunch',
      'image': '../assets/images/sample.jpg',
      'description':
          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title: Text('News', style: TextStyle(color: AppTheme.lightGreyColor)),
        iconTheme: IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TrafficIncidentsScreen()),
                );
              },
              child: Text('Get Traffic Incident Data'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newsData.length,
              itemBuilder: (context, index) {
                return _buildNewsItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(int index) {
    return GestureDetector(
      onTap: () {
        // Handle news item tap
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                newsData[index]['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              newsData[index]['title'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              'Source: ${newsData[index]['source']}',
              style: TextStyle(
                color: AppTheme.lightGreyColor,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              newsData[index]['description'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
                color: AppTheme.lightGreyColor,
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  color: AppTheme.lightGreyColor,
                  onPressed: () {
                    // Handle share button
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrafficIncidentsScreen extends StatefulWidget {
  @override
  _TrafficIncidentsScreenState createState() => _TrafficIncidentsScreenState();
}

class _TrafficIncidentsScreenState extends State<TrafficIncidentsScreen> {
  late Future<List<TrafficIncident>> futureIncidents;

  @override
  void initState() {
    super.initState();
    futureIncidents = fetchTrafficIncidents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traffic Incidents'),
      ),
      body: FutureBuilder<List<TrafficIncident>>(
        future: futureIncidents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No traffic incidents found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final incident = snapshot.data![index];
                return ListTile(
                  title: Text(incident.title),
                  subtitle: Text(incident.description),
                  leading: Icon(Icons.traffic),
                  trailing: Text('${incident.latitude}, ${incident.longitude}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
