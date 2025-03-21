// route_manager.dart
import 'package:flutter/material.dart';

import '../futures/Wallets/wallets_screen.dart';
import '../futures/splash/splash_screen.dart';
import '../futures/wallet_details/wallet_details_screen.dart';


class RouteManager {
  static const String splashRoute = '/';
  
  static const String walletsRoute = '/wallets';
  static const String walletDetailsRoute = '/walletDetails';

  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case walletsRoute:
        return MaterialPageRoute(builder: (_) => const WalletsScreen());
      
      case walletDetailsRoute:
        final walletId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => WalletDetailsScreen(walletId: walletId),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

 
  
}

