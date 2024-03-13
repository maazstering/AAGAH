import 'package:camera/camera.dart';

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  late Future<void> _initializeControllerFuture;

  Future<void> initialize() async {
    // Get a list of available cameras
    _cameras = await availableCameras();

    // Initialize the first camera in the list
    _controller = CameraController(
      _cameras[0], // Use the first available camera
      ResolutionPreset.medium,
    );

    // Initialize the controller future
    _initializeControllerFuture = _controller.initialize();
  }

  CameraController get controller => _controller;
  Future<void> get initializeControllerFuture => _initializeControllerFuture;
}
