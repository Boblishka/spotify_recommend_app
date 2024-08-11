import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  void _authenticate(BuildContext context) async {
    final accessToken = await _authService.authenticate();

    if (accessToken != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(accessToken: accessToken)));
    } else {
      // Handle authentication failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Spotify'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authenticate(context),
          child: Text('Login with Spotify'),
        ),
      ),
    );
  }
}
