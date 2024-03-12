import 'package:app/feed.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true, // Center the app bar title for aesthetics
      ),
      body: SingleChildScrollView(
        // Allow content to scroll if it overflows
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image upload section (replace with actual image selection logic)
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70.0, // Adjust radius as needed
                      backgroundImage: AssetImage(
                          '../assets/images/profile.jpg'), // Placeholder image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          // Handle image upload logic (e.g., using a camera or gallery picker)
                          print('Image upload button pressed');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0), // Add spacing

              // Enhanced form fields with error handling and decoration
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        errorText: 'Name is required', // Example error message
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null; // No error
                      },
                    ),
                    SizedBox(height: 10.0), // Adjust spacing

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Age',
                        errorText:
                            'Age must be a number', // Example error message
                      ),
                      keyboardType:
                          TextInputType.number, // Enforce numeric input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        try {
                          int.parse(value);
                          return null; // No error
                        } catch (e) {
                          return 'Invalid age. Please enter a number.';
                        }
                      },
                    ),
                    SizedBox(height: 10.0), // Adjust spacing

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Bio',
                        hintText:
                            'Enter a short description about yourself', // Optional hint text
                      ),
                      maxLines: 3, // Allow multiple lines for longer bios
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0), // Add spacing

              // Enhanced button with rounded corners and potential gradient
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Feed(),
                      ));
                  //print('Submit button pressed');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // Consider using a gradient for a more visually appealing button (refer to resources below)
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
