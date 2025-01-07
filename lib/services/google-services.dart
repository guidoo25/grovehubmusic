import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/models/authmodel.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null;

      final googleKey = await account.authentication;

      final response = await http.post(
        Uri.parse('${Enviroments.apiUrl}/auth/google'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': googleKey.idToken,
          'email': account.email,
          'name': account.displayName,
        }),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to sign in with Google: ${response.body}');
      }
    } catch (e) {
      print('Error in Google Sign In: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
