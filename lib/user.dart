import 'package:flutter/foundation.dart';
import 'dart:convert';

// Packages
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserData extends ChangeNotifier {
  // Variables
  final storage = const FlutterSecureStorage();
  Map user = {};

  // API Calls
  Future getUser() async {
    String? userId = await storage.read(key: 'user_id');

    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/users/$userId/');

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      user = json.decode(utf8.decode(response.bodyBytes));
      return true;
    } else {
      // If that response was not OK, throw an error.
      storage.deleteAll();
      return false;
    }
  }

  void setUser(Map userData) {
    user = userData;
  }

  Future updateUser() async {
    String? userId = await storage.read(key: 'user_id');

    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/users/$userId/');

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      user = json.decode(utf8.decode(response.bodyBytes));
      notifyListeners();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
