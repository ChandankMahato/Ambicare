import 'dart:async';
import 'package:ambicare_driver/screens/main_screen.dart';
import 'package:ambicare_driver/services/storage.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../main.dart';
import '../screens/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () async {
      // final bool? isAdmin = await Database.isAdmin();
      String? token = await Storage.getToken();
      // if (token != null) {
      //   allAmbulances = await Database.getAllAmbulances();
      // }
      await navigatorKey.currentState!.pushNamedAndRemoveUntil(
          token == null ? Signin.id : HomePage.id, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.3,
          ),
          Image.asset("images/splash.png"),
          Center(
            child: Text(
              'Ambicare',
              style: kAppName.copyWith(
                color: kDarkRedColor,
                fontWeight: FontWeight.w900,
                fontFamily: 'Ubuntu',
                fontSize: 35,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: kLightRedColor,
                height: 50,
                child: const Center(
                  child: Text(
                    'Racing for a cause',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhite,
                      fontFamily: 'Ubuntu',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
