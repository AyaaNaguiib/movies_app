import 'package:flutter/material.dart';

import '../presentaions/screens/home/home.dart';
import '../presentaions/screens/home/tabs/search/search.dart';
import '../presentaions/screens/splash_screen/splash.dart';

class RoutesManager {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String search = '/search';

  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => Splash()
        );
      case home:
        return MaterialPageRoute(builder: (context)=> Home()
        );
      case search:
        return MaterialPageRoute(builder: (context)=> SearchScreen()
        );
    }
  }
}