import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Enviroments {
  initEnviroments() async {
    await dotenv.load(fileName: ".env");
  }

  static Color primaryColor = Color.fromARGB(255, 19, 119, 185);

  static String apiUrl = dotenv.env['API_URL'] ?? '';
  static String imageurl = dotenv.env['imagebase'] ?? '';
  static String musicurl = dotenv.env['music_path'] ?? '';

  Future<String> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('rol') ?? '';
  }
}
