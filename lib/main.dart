import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readtoday/provider/single.dart';
import 'package:readtoday/screens/splash/splash.dart';
import 'Constants/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ['your-test-device-id']),
  );

  // Set preferred orientations for the app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for the navigation bar to white
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      // Status bar color
      statusBarIconBrightness: Brightness.dark,
      // Status bar icons (dark color)
      systemNavigationBarColor: Colors.white,
      // Navigation bar color (white)
      systemNavigationBarIconBrightness: Brightness.dark,
      // Navigation bar icons (dark color)
      systemNavigationBarDividerColor: Colors.white,
      // Divider color of system navigation bar
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SingleServicesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String style = GoogleFonts.alexandria().toString();
    return MaterialApp(
      title: "ReadyToday",
      color: Colorss().MainColor,
      theme: ThemeData(
        fontFamily: style,
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.alexandria(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.alexandria(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
          bodySmall: GoogleFonts.alexandria(fontSize: 17, color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: [const Locale('ar', 'EG')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(),
    );
  }
}
