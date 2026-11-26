import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class MockUser extends ChangeNotifier {
  static final MockUser _instance = MockUser._internal();
  factory MockUser() => _instance;
  MockUser._internal();

  bool _isLoggedIn = false;
  bool _isGuest = false;
  String _userId = "";
  String _name = "Guest User";
  String _email = "";
  String _phone = "";
  String _gender = "Female";
  String _state = "Nagaland";
  String _country = "India";
  final Set<String> _votedSubmissions = {};

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;
  String get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get gender => _gender;
  String get state => _state;
  String get country => _country;
  Set<String> get votedSubmissions => _votedSubmissions;

  // Initialize session from local storage on app boot
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString('auth_user_id');
      if (savedId != null && savedId.isNotEmpty) {
        _userId = savedId;
        _name = prefs.getString('auth_user_name') ?? 'User';
        _email = prefs.getString('auth_user_email') ?? '';
        _phone = prefs.getString('auth_user_phone') ?? '';
        _gender = prefs.getString('auth_user_gender') ?? 'Female';
        _state = prefs.getString('auth_user_state') ?? 'Nagaland';
        _country = prefs.getString('auth_user_country') ?? 'India';
        _isLoggedIn = true;
        _isGuest = false;
        notifyListeners();
      } else {
        _isLoggedIn = false;
        _isGuest = false;
        _userId = "";
        _name = "Guest User";
        _email = "";
      }
    } catch (e) {
      debugPrint("Error initializing user state: $e");
    }
  }

  // Set logged in user from Firestore
  Future<void> setLoggedInUser(UserModel user) async {
    _userId = user.userId;
    _name = user.fullName.isNotEmpty ? user.fullName : user.email.split('@').first;
    _email = user.email;
    _phone = user.phone;
    _gender = user.gender;
    _state = user.state;
    _country = user.country;
    _isLoggedIn = true;
    _isGuest = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_user_id', _userId);
      await prefs.setString('auth_user_name', _name);
      await prefs.setString('auth_user_email', _email);
      await prefs.setString('auth_user_phone', _phone);
      await prefs.setString('auth_user_gender', _gender);
      await prefs.setString('auth_user_state', _state);
      await prefs.setString('auth_user_country', _country);
    } catch (e) {
      debugPrint("Error saving session: $e");
    }
  }

  void loginAsGuest() {
    _isLoggedIn = false;
    _isGuest = true;
    _userId = "";
    _name = "Guest User";
    _email = "";
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _isGuest = false;
    _userId = "";
    _name = "Guest User";
    _email = "";
    _phone = "";
    _gender = "";
    _state = "";
    _votedSubmissions.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_user_id');
      await prefs.remove('auth_user_name');
      await prefs.remove('auth_user_email');
      await prefs.remove('auth_user_phone');
      await prefs.remove('auth_user_gender');
      await prefs.remove('auth_user_state');
      await prefs.remove('auth_user_country');
    } catch (e) {
      debugPrint("Error clearing session: $e");
    }
  }

  /// Deletes the user profile remotely in Firestore and clears local device session.
  /// Complies with Apple Store (5.1.1(v)) and Google Play account deletion policies.
  Future<bool> deleteAccount() async {
    final uid = _userId;
    final email = _email;
    bool remoteDeleted = true;
    if (uid.isNotEmpty || email.isNotEmpty) {
      try {
        final fb = FirebaseService();
        remoteDeleted = await fb.deleteUserAccount(uid, userEmail: email);
      } catch (e) {
        debugPrint("Error deleting remote account in MockUser: $e");
        remoteDeleted = false;
      }
    }
    await logout();
    return remoteDeleted;
  }

  bool hasVoted(String submissionId) => _votedSubmissions.contains(submissionId);

  bool toggleVote(String submissionId) {
    if (_votedSubmissions.contains(submissionId)) {
      _votedSubmissions.remove(submissionId);
      notifyListeners();
      return false;
    } else {
      _votedSubmissions.add(submissionId);
      notifyListeners();
      return true;
    }
  }
}
