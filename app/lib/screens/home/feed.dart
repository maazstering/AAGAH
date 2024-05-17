import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:app/widgets/variables.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/bottomNavigationCard.dart';
import 'package:app/widgets/likeButton.dart';
import 'package:app/screens/home/comment.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  List<Post> posts = [];
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  LatLng? _currentP;

  @override
  void initState() {
    super.initState();
    fetchData();
    getLocationUpdates();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token != null) {
        final uri = Uri.parse('${Variables.address}/social');
        final response = await http.get(
          uri,
          headers: {'Authorization': 'Bearer $token'},
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        final jsonData = json.decode(response.body);
        setState(() {
          posts = (jsonData['posts'] as List)
              .map((data) => Post.fromJson(data))
              .toList();
        });
      } else {
        print('Token is null');
        // Handle the case where the token is null (e.g., navigate to login)
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
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
      ),
      backgroundColor: AppTheme.bgColor,
      body: _currentP == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: GoogleMap(
                      onMapCreated: (GoogleMapController controller) =>
                          _mapController.complete(controller),
                      initialCameraPosition:
                          CameraPosition(target: _currentP!, zoom: 13),
                      markers: {
                        Marker(
                          markerId: const MarkerId('_currentLocation'),
                          icon: BitmapDescriptor.defaultMarker,
                          position: _currentP!,
                        ),
                      },
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Container(
                    color: AppTheme.bgColor,
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) => feedItem(index, context),
                    ),
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

  Widget feedItem(int index, BuildContext context) {
    final post = posts[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: BorderRadius.circular(1.0),
        border: Border.all(
          color: AppTheme.greyColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/user_placeholder.png'),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightGreyColor,
                      ),
                    ),
                    Text(
                      post.author.email,
                      style: const TextStyle(color: AppTheme.lightGreyColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.lightGreyColor,
                ),
                onPressed: () {
                  // Handle more options
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            post.content,
            style: const TextStyle(color: AppTheme.lightGreyColor),
          ),
          const SizedBox(height: 8.0),
          if (post.images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                post.images[0],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const AnimatedLikeButton(),
                    Text(
                      '${post.likes.length} likes',
                      style: const TextStyle(color: AppTheme.lightGreyColor),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CommentPage()),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.comment,
                          color: AppTheme.greyColor),
                      const SizedBox(width: 5),
                      Text(
                        'View all ${post.comments.length} comments',
                        style: const TextStyle(color: AppTheme.lightGreyColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            post.createdAt,
            style:
                const TextStyle(color: AppTheme.lightGreyColor, fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}

class Post {
  final String id;
  final String content;
  final Author author;
  final List<dynamic> comments;
  final List<dynamic> likes;
  final List<dynamic> shares;
  final List<dynamic> images;
  final String createdAt;

  Post({
    required this.id,
    required this.content,
    required this.author,
    required this.comments,
    required this.likes,
    required this.shares,
    required this.images,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      content: json['content'],
      author: Author.fromJson(json['author']),
      comments: json['comments'],
      likes: json['likes'],
      shares: json['shares'],
      images: json['images'],
      createdAt: json['createdAt'],
    );
  }
}

class Author {
  final String id;
  final String email;
  final String name;
  final String role;

  Author({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
    );
  }
}
