import 'dart:async';
import 'dart:convert';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/components/widgets/bottomNavigationCard.dart';
import 'package:app/components/widgets/likeButton.dart';
import 'package:app/screens/home/comment.dart';
import 'package:app/screens/home/mapScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeleton_text/skeleton_text.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  List<Post> posts = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  bool hasMore = true;

  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  LatLng? _currentP;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    getLocationUpdates();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMore &&
          !isLoading) {
        fetchData(page: currentPage + 1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void decodeToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print('Decoded Token: $decodedToken');
    bool isTokenExpired = JwtDecoder.isExpired(token);
    print('Is Token Expired: $isTokenExpired');
  }

  List<Post> parsePosts(String responseBody) {
    final parsed = json.decode(responseBody);
    return (parsed['posts'] as List)
        .map<Post>((json) => Post.fromJson(json))
        .toList();
  }

  Future<void> fetchData({int page = 1}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token != null) {
        print('Token retrieved from SharedPreferences: $token');

        // Decode and print token
        decodeToken(token);

        final uri = Uri.parse('${Variables.address}/social?page=$page');
        final response =
            await http.get(uri, headers: {'Authorization': 'Bearer $token'});

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final List<Post> fetchedPosts = parsePosts(response.body);

          setState(() {
            currentPage = json.decode(response.body)['currentPage'];
            totalPages = json.decode(response.body)['totalPages'];
            hasMore = currentPage < totalPages;
            posts.addAll(fetchedPosts);
            isLoading = false;
          });
        } else if (response.statusCode == 401) {
          print('Unauthorized: Token may be invalid or expired');
          // Handle token expiration, e.g., navigate to login or refresh token
        } else {
          print('Failed to load data: ${response.statusCode}');
        }
      } else {
        print('Token is null');
        // Handle the case where the token is null (e.g., navigate to login)
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
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

  Future<void> toggleLike(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      final likeUri = Uri.parse('${Variables.address}/social/${post.id}/like');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      try {
        http.Response response;
        if (post.isLikedByUser) {
          response = await http.delete(likeUri, headers: headers);
        } else {
          response = await http.post(likeUri, headers: headers);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            post.toggleLike();
          });
        } else {
          print('Failed to like/unlike post: ${response.statusCode}');
        }
      } catch (e) {
        print('Error liking/unliking post: $e');
      }
    } else {
      print('Token is null');
      // Handle the case where the token is null (e.g., navigate to login)
    }
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
            const SizedBox(width: 8),
          ],
        ),
      ),
      backgroundColor: AppTheme.bgColor,
      body: _currentP == null
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    hasMore) {
                  fetchData(page: currentPage + 1);
                }
                return false;
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(),
                            ),
                          );
                        },
                        child: GoogleMap(
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
                          onTap: (LatLng location) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Container(
                      color: AppTheme.bgColor,
                      child: ListView.builder(
                        itemCount: posts.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == posts.length) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 10,
                              itemBuilder: (context, index) => ListTile(
                                leading: SkeletonAnimation(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                                title: SkeletonAnimation(
                                  child: Container(
                                    width: double.infinity,
                                    height: 10.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                subtitle: SkeletonAnimation(
                                  child: Container(
                                    width: double.infinity,
                                    height: 10.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                            );
                          }
                          return feedItem(index, context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
          const SizedBox(height: 10),
          Text(
            post.content,
            style: const TextStyle(color: AppTheme.lightGreyColor),
          ),
          const SizedBox(height: 8.0),
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: post.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AnimatedLikeButton(
                      isLiked: post.isLikedByUser,
                      onLikePressed: () => toggleLike(post),
                    ),
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
                        builder: (context) => CommentPage(postId: post.id),
                      ),
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
  List<dynamic> likes;
  final List<dynamic> shares;
  final String imageUrl;
  final String createdAt;
  bool isLikedByUser;

  Post({
    required this.id,
    required this.content,
    required this.author,
    required this.comments,
    required this.likes,
    required this.shares,
    required this.imageUrl,
    required this.createdAt,
    required this.isLikedByUser,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      content: json['content'],
      author: Author.fromJson(json['author']),
      comments: json['comments'] ?? [],
      likes: json['likes'] ?? [],
      shares: json['shares'] ?? [],
      imageUrl: '${Variables.address}${json['imageUrl']}', // Construct full URL
      createdAt: json['createdAt'],
      isLikedByUser: json['isLikedByUser'] ?? false,
    );
  }

  void toggleLike() {
    isLikedByUser = !isLikedByUser;
    if (isLikedByUser) {
      likes.add("new_like");
    } else {
      likes.removeWhere((like) => like == "new_like");
    }
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
