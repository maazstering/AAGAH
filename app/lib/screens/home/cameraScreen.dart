import 'dart:convert';
import 'dart:io';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/components/widgets/bottomNavigationCard.dart';
import 'package:app/components/widgets/gradientbutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http_parser/http_parser.dart'; // Add this import for MediaType

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

  // Function to decode and print token details
  void decodeToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print('Decoded Token: $decodedToken');
    bool isTokenExpired = JwtDecoder.isExpired(token);
    print('Is Token Expired: $isTokenExpired');
  }

  // Function to send post request to backend
  Future<void> _createPost() async {
    try {
      setState(() {
        _isUploading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token != null) {
        print('Token retrieved from SharedPreferences: $token');

        // Decode and print token
        decodeToken(token);

        final url = Uri.parse('${Variables.address}/social');

        String content = _captionController.text;
        print('Content: $content'); // Debug print

        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'content': content,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 201) {
          print('Post created successfully');
          setState(() {
            _captionController.clear();
            _image = null;
          });
          _showSuccessDialog(); // Show success dialog
        } else if (response.statusCode == 401) {
          print('Unauthorized: Token may be invalid or expired');
          // Handle token expiration, e.g., navigate to login or refresh token
        } else {
          print('Error creating post: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } else {
        print('Token is null');
        // Handle the case where the token is null (e.g., navigate to login)
      }
    } catch (e) {
      print('Error creating post: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Function to show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Your post has been created successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              const SizedBox(), // Removed placeholder image
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
