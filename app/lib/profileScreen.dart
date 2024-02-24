import 'package:flutter/material.dart';


class profilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.favorite), // Icon below the app bar
            SizedBox(height: 20.0), // Spacer
            TextField(decoration: InputDecoration(labelText: 'Field 1')),
            SizedBox(height: 20.0), // Spacer
            TextField(decoration: InputDecoration(labelText: 'Field 2')),
            SizedBox(height: 20.0), // Spacer
            TextField(decoration: InputDecoration(labelText: 'Field 3')),
            SizedBox(height: 20.0), // Spacer
            TextField(decoration: InputDecoration(labelText: 'Field 4')),
            Spacer(), // Expands to occupy all remaining space
            ElevatedButton(
              onPressed: () {
                // Add your button logic here
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
