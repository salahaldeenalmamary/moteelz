// Create a new file: extensions/navigation_extension.dart
import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  
  Future<T?> push<T>(Widget widget) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

Future<T?> offAllNamed<T>(String routeName, {Object? arguments}) {
  return Navigator.of(this).pushNamedAndRemoveUntil(
    routeName,
    (Route<dynamic> route) => false, 
    arguments: arguments,
  );
}




  Future<T?> pushReplacement<T>(Widget widget) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  
  void pop<T>([T? result]) {
    return Navigator.of(this).pop(result);
  }
 
}
