import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesServer {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      return json.decode(prefs.getString(key) ?? '');
    } on Exception catch (e) {
      debugPrint(e.toString());
      debugPrint('Unable to retrieve data for key: $key');
      rethrow;
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      prefs.setString(key, json.encode(value));
    } on Exception catch (e) {
      debugPrint(e.toString());
      debugPrint('Unable to save data for key: $key');
      rethrow;
    }
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      prefs.remove(key);
    } on Exception catch (e) {
      debugPrint(e.toString());
      debugPrint('Unable to remove data for key: $key');
      rethrow;
    }
  }
}
