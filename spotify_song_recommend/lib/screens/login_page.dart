import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                String? token = await _authService.authenticate();
                if (token != null) {
                  // If authentication is successful, navigate to the home page
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // If authentication fails, show an error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to authenticate with Spotify')),
                  );
                }
              },
              child: Text('Login with Spotify'),
            ),
          ],
        ),
      ),
    );
  }
}
