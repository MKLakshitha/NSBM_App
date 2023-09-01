import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n_reach_nsbm/pages/home_page.dart';
import 'package:n_reach_nsbm/pages/nroad_page.dart';
import 'package:n_reach_nsbm/pages/splash_screen.dart';
import 'package:n_reach_nsbm/view/onboarding_page.dart';
import 'package:n_reach_nsbm/view/phone_page.dart';
import 'package:n_reach_nsbm/view/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? seenOnboard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  seenOnboard = prefs.getBool('seenOnboard') ?? false;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //meka add krpn
    mobileDeviceWidth = MediaQuery.of(context).size.width;
    mobileDeviceHeight = MediaQuery.of(context).size.height;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'N-Reach',
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(
          Theme.of(context).textTheme,
        ),
        //mek add krpn !! lakshu
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Set the default color here
            ),
          ),
          fontFamily: 'DM Sans',
          appBarTheme: const AppBarTheme(
              titleSpacing: 1.0,
              //titleTextStyle: TextStyle(color: Colors.black),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color:
                    Colors.black, // Change the color of the leading icon here
              ),
              elevation: 0),
        
      ),
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) {
          return const SplashScreen();
        },
        '/signin': (context) => const SignInPage(),
        '/home': (context) => const HomePage(),
        '/onboarding': (context) {
          if (!seenOnboard!) {
            // Mark onboarding as seen and show OnBoardingPage
            seenOnboard = true;
            _saveSeenOnboardToPrefs(); // Save to SharedPreferences
            return const OnBoardingPage();
          } else {
            return const MapPage();
          }
        },
        'phone': (context) => PhoneNumberInputScreen(),
        'map': (context) => const MapPage(),
      },
    );
  }

  // Function to save seenOnboard value to SharedPreferences
  Future<void> _saveSeenOnboardToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboard', true);
  }
}
