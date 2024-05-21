import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/gradientButton.dart';
import 'package:app/widgets/variables.dart';
import 'package:app/widgets/bottomNavigationCard.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _captionPopulated = false;
  bool _isUploading = false;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  // Function to handle image selection from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to send post request to backend
  Future<void> _createPost() async {
    try {
      setState(() {
        _isUploading = true;
      });
      final uri = Uri.parse('${Variables.address}/social');
      var request = http.MultipartRequest('POST', uri);
      request.fields['content'] = _captionController.text;

      // Include authorization header if needed
      // request.headers['Authorization'] = 'Bearer hasnusecret';

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Post created successfully');
        setState(() {
          _captionController.clear();
          _image = null;
        });
      } else {
        print('Error creating post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating post: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Post',
            style: TextStyle(color: AppTheme.whiteColor)),
        backgroundColor: AppTheme.bgColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _captionController,
                onChanged: (value) {
                  setState(() {
                    _captionPopulated = value.isNotEmpty;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (_image != null)
              Image.file(_image!)
            else
              Image.asset(
                  'assets/images/user_placeholder.png'), // Use a placeholder if no image is selected
            GradientButton(
              text: 'Select Image',
              onPressed: _pickImage,
              settings: false,
            ),
            const SizedBox(height: 20),
            GradientButton(
              text: _isUploading ? 'Uploading...' : 'Create Post',
              onPressed: () {
                if (_captionPopulated && !_isUploading) {
                  _createPost();
                }
              },
              settings:
                  true, // Adjust based on your GradientButton implementation.
            ),
          ],
        ),
      ),
      backgroundColor: AppTheme.bgColor,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle navigation to different screens
        },
      ),
    );
  }
}
