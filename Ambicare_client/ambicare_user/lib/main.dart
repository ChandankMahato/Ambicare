import 'package:ambicare_user/screens/forgot_password/change_password.dart';
import 'package:ambicare_user/screens/forgot_password/forgot_password.dart';
import 'package:ambicare_user/screens/forgot_password/phone_verification.dart';
import 'package:ambicare_user/screens/history_maps_page.dart';
import 'package:ambicare_user/screens/history_screen.dart';
import 'package:ambicare_user/screens/khalti_payment.dart';
import 'package:ambicare_user/screens/maps_page.dart';
import 'package:ambicare_user/screens/onboarding.dart';
import 'package:ambicare_user/screens/profile.dart';
import 'package:ambicare_user/screens/requests_screen.dart';
import 'package:ambicare_user/screens/user_support.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/phone_verification.dart';
import 'screens/user_home.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../state/password_eye.dart';
import '../state/phone_verification_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Ambicare());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Ambicare extends StatelessWidget {
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
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        routes: {
          OnBoarding.id: (context) => const OnBoarding(),
          Signin.id: (context) => const Signin(),
          Signup.id: (context) => const Signup(),
          SplashScreen.id: (context) => const SplashScreen(),
          PhoneVerification.id: (context) => PhoneVerification(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          UserHome.id: (context) => const UserHome(),
          UserSupport.id: (context) => const UserSupport(),
          Profile.id: (context) => const Profile(),
          Requests.id: (context) => const Requests(),
          History.id: (context) => const History(),
          MapsPage.id: (context) => MapsPage(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          HistoryMapsPage.id: (context) => HistoryMapsPage(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          Payment.id: (context) => const Payment(),
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
