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
import 'package:http_parser/http_parser.dart';

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void decodeToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print('Decoded Token: $decodedToken');
    bool isTokenExpired = JwtDecoder.isExpired(token);
    print('Is Token Expired: $isTokenExpired');
  }

  Future<void> _createPost() async {
    try {
      setState(() {
        _isUploading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token != null) {
        print('Token retrieved from SharedPreferences: $token');

        decodeToken(token);

        final url = Uri.parse('${Variables.address}/social');

        var request = http.MultipartRequest('POST', url)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['content'] = _captionController.text;

        if (_image != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            _image!.path,
            contentType: MediaType('image', 'jpeg'),
          ));
        }

        var response = await request.send();

        if (response.statusCode == 201) {
          print('Post created successfully');
          setState(() {
            _captionController.clear();
            _image = null;
          });
          _showSuccessDialog();
        } else if (response.statusCode == 401) {
          print('Unauthorized: Token may be invalid or expired');
        } else {
          print('Error creating post: ${response.statusCode}');
          response.stream.transform(utf8.decoder).listen((value) {
            print('Response body: $value');
          });
        }
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error creating post: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.whiteColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: const Text('Create Post',
              style: TextStyle(color: AppTheme.whiteColor)),
        ),
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
            if (_image != null) Image.file(_image!) else const SizedBox(),
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
              settings: false,
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
