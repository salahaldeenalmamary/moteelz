
import 'package:flutter/material.dart';
import 'dart:async';

import '../../routes/route_manager.dart';
import '../../utils/image.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RouteManager.walletsRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Image.asset(
         ImageConstants.logo,
          width: 200,
          height: 200,
          
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel any ongoing timers when widget is disposed
    super.dispose();
  }
}