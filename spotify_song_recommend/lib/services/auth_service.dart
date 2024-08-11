import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String clientId = "f49acda5718a4acfbe0d0e47f0ea78c9";
  final String clientSecret = "a84a0a4b11df4760a3171be043dbaadc";
  final String redirectUri = "http://localhost:8888/callback";

  Future<String?> authenticate() async {
    // Step 1: Authorization request
    final url = "https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=user-top-read";

    // Step 2: Handle redirect and get authorization code
    final result = await FlutterWebAuth.authenticate(
        url: url, callbackUrlScheme: "http");

    final code = Uri.parse(result).queryParameters['code'];

    // Step 3: Exchange authorization code for access token
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' +
            base64Encode(utf8.encode('$clientId:$clientSecret')),
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code!,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final accessToken = json.decode(response.body)['access_token'];
      return accessToken;
    } else {
      // Handle error
      print("Failed to authenticate: ${response.statusCode}");
      return null;
    }
  }
}
