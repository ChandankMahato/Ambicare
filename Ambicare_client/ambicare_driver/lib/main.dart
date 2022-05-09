import 'package:ambicare_driver/screens/forgot_password/change_password.dart';
import 'package:ambicare_driver/screens/forgot_password/forgot_password.dart';
import 'package:ambicare_driver/screens/forgot_password/phone_verification.dart';
import 'package:ambicare_driver/screens/main_screen.dart';
import 'package:ambicare_driver/screens/maps_screen.dart';
import 'package:ambicare_driver/screens/signin_screen.dart';
import 'package:ambicare_driver/screens/splash_screen.dart';
import 'package:ambicare_driver/state/password_eye.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'state/phone_verification_state.dart';

Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
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
      ],
      builder: (context, _) => MaterialApp(
        title: 'Ambicare',
        theme: ThemeData(
          fontFamily: 'Ubuntu',
        ),
        initialRoute: SplashScreen.id,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        routes: {
          SplashScreen.id: ((context) => const SplashScreen()),
          Signin.id: (context) => const Signin(),
          HomePage.id: (context) => HomePage(),
          MapsPage.id: (context) => MapsPage(
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
