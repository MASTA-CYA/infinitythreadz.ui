import 'package:flutter/foundation.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';
import 'package:infinity_threadz/common/services/shared_preferences_server.dart';
import 'package:infinity_threadz/user-component/models/user_model.dart';

/// Holds the signed-in user for the session.
///
/// This is a demo build with no backend: signing in always loads the
/// demo shopper from [DemoData], and only the theme preference is
/// persisted locally with shared_preferences.
class UserService extends ChangeNotifier {
  static const String userKey = 'USER';

  final SharedPreferencesServer _preferences = SharedPreferencesServer();
  User? _user;
  bool _isDarkMode = false;

  static final UserService _instance = UserService._internal();

  /// Returns the single shared instance.
  factory UserService() => _instance;

  UserService._internal();

  /// Loads the demo user as the signed-in user.
  void signIn() {
    _user = DemoData.user()..isDarkMode = _isDarkMode;
    _preferences.save(userKey, _user);
    notifyListeners();
  }

  /// Clears the signed-in user.
  void signOut() {
    _user = null;
    notifyListeners();
  }

  void changeTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    if (_user != null) {
      _user!.isDarkMode = isDarkMode;
      _preferences.save(userKey, _user);
    }
    notifyListeners();
  }

  /// Returns the signed-in user, loading the demo user if needed.
  User getUser() {
    if (_user == null) {
      signIn();
    }
    return _user!;
  }

  Future<bool> getInitTheme() async {
    try {
      return User.fromJson(await _preferences.read(userKey)).isDarkMode;
    } on Exception {
      return false;
    }
  }
}
