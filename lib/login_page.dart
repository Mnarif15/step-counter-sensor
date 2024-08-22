// lib/login_page.dart

import 'package:flutter/material.dart';
import 'package:sensor2/step_counter.dart';
import 'authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background image using BoxDecoration
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hiking-sunset-wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 0), // Adjusted the height to make it higher
              // Add the app name at the top with a custom font
              Text(
                'StepMaster',
                style: TextStyle(
                  fontSize: 55, // Adjusted the font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'High Summit', // Replace 'YourCustomFont' with the desired font
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 300), // Added more space between the title and the card
              Card(
                elevation: 5.0,
                margin: EdgeInsets.all(16.0),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login Page',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          bool auth = await Authentication.authentication();
                          print("can authenticate: $auth");
                          if (auth) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StepCounter()),
                            );
                          }
                        },
                        icon: Icon(Icons.fingerprint),
                        label: Text("Authenticate"),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
