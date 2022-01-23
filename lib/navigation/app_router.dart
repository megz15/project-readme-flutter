import 'package:flutter/material.dart';
import 'package:readme/screens/splash_screen.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;

  AppRouter({
    required this.appStateManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
  }

  @override
  void dispose(){
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
      if (!appStateManager.isInitialized) SplashScreen.page(),
      if (appStateManager.isInitialized && (!appStateManager.isLoggedInAndStoredInSession || !appStateManager.isLoggedInAsGuest)) LoginScreen.page(),
      if (appStateManager.isLoggedInAsGuest && !appStateManager.isOnboardingComplete) OnboardingScreen.page(),
      if (appStateManager.isLoggedInAndStoredInSession || appStateManager.isOnboardingComplete) Home.page(appStateManager.getSelectedTab),
      if (appStateManager.isBookOpen) BookScreen.page(appStateManager.bookOpenedMirrorLink, appStateManager.isOpenedBookURL),
      if (appStateManager.didSelectUser) ProfileScreen.page(appStateManager.getProfileFromSession()),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result){
    if (!route.didPop(result)){
      return false;
    }
    if (route.settings.name == ReadmePages.onboardingPath) appStateManager.logout();
    if (route.settings.name == ReadmePages.book) appStateManager.changeBookState(false, '', false);
    if (route.settings.name == ReadmePages.profilePath) appStateManager.tapOnProfile(false);
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}