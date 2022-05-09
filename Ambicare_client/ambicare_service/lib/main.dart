import 'package:ambicare_service/screens/forgot_password/change_password.dart';
import 'package:ambicare_service/screens/forgot_password/forgot_password.dart';
import 'package:ambicare_service/screens/forgot_password/phone_verification.dart';
import 'package:ambicare_service/screens/history_maps_screen.dart';
import 'package:ambicare_service/screens/main_screen.dart';
import 'package:ambicare_service/screens/maps_screen.dart';
import 'package:ambicare_service/state/ambulance_type_state.dart';
import 'package:ambicare_service/state/filter_status_colour_state.dart';
import 'package:ambicare_service/state/filter_status_value.dart';
import 'package:ambicare_service/state/filter_type_colour_state.dart';
import 'package:ambicare_service/state/filter_type_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/phone_verification.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../state/password_eye.dart';
import '../state/phone_verification_state.dart';
import 'package:firebase_core/firebase_core.dart';

// String? token;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
  runApp(Ambicare());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Ambicare extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PasswordEyeState()),
        ChangeNotifierProvider(create: (context) => PhoneVerificationSate()),
        ChangeNotifierProvider(create: (context) => AmbulanceTypeState()),
        ChangeNotifierProvider(create: (context) => FilterStatusColourState()),
        ChangeNotifierProvider(create: (context) => FilterTypeColourState()),
        ChangeNotifierProvider(create: (context) => FilterTypeState()),
        ChangeNotifierProvider(create: (context) => FilterStatusState()),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Ambicare',
        initialRoute: SplashScreen.id,
        theme: ThemeData(
          fontFamily: 'Ubuntu',
        ),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        routes: {
          Signin.id: (context) => const Signin(),
          Signup.id: (context) => const Signup(),
          SplashScreen.id: (context) => const SplashScreen(),
          PhoneVerification.id: (context) => PhoneVerification(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          HomePage.id: (context) => HomePage(),
          MapsPage.id: (context) => const MapsPage(),
          HistoryMapsPage.id: (context) => HistoryMapsPage(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          ForgotPassword.id: (context) => const ForgotPassword(),
          ChangePassword.id: (context) => ChangePassword(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          PhoneVerificationForPassword.id: (context) =>
              PhoneVerificationForPassword(
                  args: ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>),
        },
      ),
    );
  }
}
