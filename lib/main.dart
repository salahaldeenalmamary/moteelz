import 'package:context_plus/context_plus.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/my_app.dart';


void main() {
  ErrorWidget.builder = ContextPlus.errorWidgetBuilder(ErrorWidget.builder);
  FlutterError.onError = ContextPlus.onError(FlutterError.onError);
  
  runApp(ContextPlus.root(

    additionalWatchers: [
       SignalContextWatcher.instance,
    ],
    child: const MyApp(),
  ));
}
