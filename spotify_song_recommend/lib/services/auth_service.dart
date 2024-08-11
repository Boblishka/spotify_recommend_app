import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String clientId = "f49acda5718a4acfbe0d0e47f0ea78c9";
  final String clientSecret = "a84a0a4b11df4760a3171be043dbaadc";
  final String redirectUri = "http://localhost:8888/callback";


  Future<String?> authenticate() async {
    // Step 1: Construct the Spotify authorization URL
    final url =
        'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=user-read-email%20user-read-private';

    // Step 2: Use flutter_web_auth to open the webview for Spotify authentication
    final result = await FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: 'your_callback_scheme',  // This should match the beginning of your redirectUri
    );

    // Step 3: Extract the authorization code from the result
    final code = Uri.parse(result).queryParameters['code'];

    // Step 4: Exchange the authorization code for an access token
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code!,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      // Step 5: Extract the access token from the response
      final accessToken = json.decode(response.body)['access_token'];
      return accessToken;
    } else {
      return null;
    }
  }
}
