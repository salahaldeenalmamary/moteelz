
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes/route_manager.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'موديلز',
      initialRoute: RouteManager.splashRoute,
      onGenerateRoute: RouteManager.generateRoute,
      theme: ThemeData(
          
          useMaterial3: true,
        primaryColor: Colors.deepPurpleAccent,
          cardColor: Colors.white,
          scaffoldBackgroundColor: Color.fromARGB(255, 250, 249, 249),
          canvasColor: Colors.white,
          cardTheme: CardTheme(color: Colors.white),
          appBarTheme:
              AppBarTheme(backgroundColor: Theme.of(context).cardColor)),
      locale: const Locale('ar'), // Set Arabic as default locale
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'), // Arabic
      ],
 
      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}
