import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/gradientbutton.dart';

class PostingScreen extends StatefulWidget {
  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  TextEditingController _captionController = TextEditingController();
  bool _captionPopulated = false;
  bool _showCameraPreview = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      await _controller.initialize();
      setState(() {}); // Trigger a rebuild after the controller is initialized
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _captionController.dispose();
    super.dispose();
  }

  // Function to send post request to backend
  Future<void> _createPost() async {
    try {
      final url = 'http://192.168.56.1:3000/social/';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'content': _captionController.text,
          // images or videos ka dalna ha
        },
      );

      if (response.statusCode == 200) {
        // Post created successfully
        print('Post created successfully');
        // Optionally, you can navigate to another screen or perform any other action here
      } else {
        // Error creating post
        print('Error creating post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Posting Screen',
          style: TextStyle(color: AppTheme.whiteColor),
        ),
        backgroundColor: AppTheme.bgColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.lightGreyColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _captionController,
                onChanged: (value) {
                  setState(() {
                    _captionPopulated = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
            SizedBox(height: 20),
            _showCameraPreview
                ? Expanded(
                    child:
                        _controller != null && _controller.value.isInitialized
                            ? CameraPreview(_controller)
                            : Center(child: CircularProgressIndicator()),
                  )
                : IconButton(
                    icon: Icon(Icons.camera_alt),
                    iconSize: 50,
                    onPressed: () {
                      setState(() {
                        _showCameraPreview = true;
                      });
                    },
                  ),
            SizedBox(height: 20),
            if (_captionPopulated && !_showCameraPreview)
              GradientButton(
                text: 'Create Post',
                onPressed: () {
                  _createPost(); // Call function to create post
                },
                settings: false,
              ),
          ],
        ),
      ),
      backgroundColor: AppTheme.bgColor,
    );
  }
}
