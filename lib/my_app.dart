import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'di/ref.dart';
import 'routes/route_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ServiceDI.initializeDependencies(context);
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
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: true,
        overscroll: false,
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
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
