import 'dart:async';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class AppStateManager extends ChangeNotifier {
  bool _initialized = false;
  bool _loggedInAndStoredInSession = false;
  bool _loggedInAsGuest = false;
  bool _onboardingComplete = false;
  bool _bookOpen = false;
  bool _isOpenedBookURL = false;
  int _selectedTab = 0;
  bool _didSelectUser = false;
  String _bookOpenedMirrorLink = '';
  GlobalKey<ConvexAppBarState> appBarKey = GlobalKey<ConvexAppBarState>();

  bool get isInitialized => _initialized;
  bool get isLoggedInAndStoredInSession => _loggedInAndStoredInSession;
  bool get isLoggedInAsGuest => _loggedInAsGuest;
  bool get isOnboardingComplete => _onboardingComplete;
  bool get isBookOpen => _bookOpen;
  bool get isOpenedBookURL => _isOpenedBookURL;
  int get getSelectedTab => _selectedTab;
  bool get didSelectUser => _didSelectUser;
  String get bookOpenedMirrorLink => _bookOpenedMirrorLink;

  void initializeApp() {
    Timer(const Duration(seconds: 2), () {
      _initialized = true;
      notifyListeners();
    });
  }

  Future<ProfileData> getProfileFromSession() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return ProfileData(
      uName: _prefs.getString("uName")!,
      fName: _prefs.getString("fName")!,
      UID: _prefs.getString("UID")!,
      pfp: _prefs.getString("pfp")!,
      timestamp: _prefs.getString("timestamp")!,
      pwd: _prefs.getString("pwd")!,
    );
  }

  void printAllSharedPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print(_prefs.getKeys());
  }

  void logInAndStoreInSession() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _loggedInAndStoredInSession = _prefs.getKeys().isNotEmpty;
    notifyListeners();
  }

  void loginWithSession(ProfileData user) async {
    //SessionManager().set("profileData", user);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("uName", user.uName);
    _prefs.setString("pfp", user.pfp);
    _prefs.setString("pwd", user.pwd);
    _prefs.setString("UID", user.UID);
    _prefs.setString("fName", user.fName);
    _prefs.setString("lName", user.lName);
    _prefs.setString("timestamp", user.timestamp);
    notifyListeners();
    //return MockLoginService().checkUserExist(user, pwd);
  }

  void loginAsGuest() {
    _loggedInAsGuest = true;
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void changeBookState(bool isTrueIfOpen, String bookLink, bool isURL) {
    _bookOpenedMirrorLink = bookLink;
    _bookOpen = isTrueIfOpen;
    _isOpenedBookURL = isURL;
    notifyListeners();
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  void logout() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _loggedInAndStoredInSession = false;
    _loggedInAsGuest = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;
    await _prefs.clear();
    initializeApp();
    notifyListeners();
  }

  void tapOnProfile(bool selected) {
    _didSelectUser = selected;
    notifyListeners();
  }
}
