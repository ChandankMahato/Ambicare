import 'dart:async';
import 'package:ambicare_user/screens/onboarding.dart';
import 'package:ambicare_user/screens/signup_screen.dart';
import 'package:ambicare_user/screens/user_home.dart';
import 'package:ambicare_user/services/database.dart';
import 'package:ambicare_user/services/location.dart';
import 'package:ambicare_user/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/constants.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

late BitmapDescriptor mapMarker;
List availableAmbulances = [];
Position? userPosition;

class _SplashScreenState extends State<SplashScreen> {
  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'images/marker-red.png');
  }

  @override
  void initState() {
    super.initState();
    setCustomMarker();
    Timer(const Duration(seconds: 4), () async {
      String? token = await Storage.getToken();
      // final bool? isAdmin = await Database.isAdmin();
      try {
        if (token != null) {
          userPosition = await Location.determinePosition();
          availableAmbulances = await Database.getAllAmbulances();
        }
        await navigatorKey.currentState!.pushNamedAndRemoveUntil(
            token == null ? OnBoarding.id : UserHome.id, (route) => false);
      } catch (ex) {
        return showSnackBar(context, ex.toString(), Colors.red);
      }
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
