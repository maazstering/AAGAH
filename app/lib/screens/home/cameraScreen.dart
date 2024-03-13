import 'package:app/widgets/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import the camera package

class PostingScreen extends StatefulWidget {
  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture =
      Future<void>.delayed(Duration.zero);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aagah'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _openCamera();
              },
              child: Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    try {
      await _initializeControllerFuture;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: CameraPreview(_controller),
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
