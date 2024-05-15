import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/gradientButton.dart';

class PostingScreen extends StatefulWidget {
  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  TextEditingController _captionController = TextEditingController();
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
      final url = 'http://192.168.56.1:3000/social';
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          // Include authorization header if you switch to using headers for token
          //"Authorization": "Bearer hasnusecret",
        },
        body: json.encode({
          'content': _captionController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Post created successfully');
        setState(() {
          _captionController.clear();
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
        title: Text('Create a New Post',
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
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(height: 20),
            if (_image != null) Image.file(_image!),
            GradientButton(
              text: 'Select Image',
              onPressed: _pickImage,
              settings: false,
            ),
            SizedBox(height: 20),
            GradientButton(
              text: 'Create Post',
              onPressed: () {
                if (_captionPopulated && !_isUploading) {
                  _createPost();
                }
              },
              settings:
                  true, // Adjust based on your GradientButton implementation. This parameter might need to be changed or removed according to your actual widget definition.
            ),
          ],
        ),
      ),
      backgroundColor: AppTheme.bgColor,
    );
  }
}
