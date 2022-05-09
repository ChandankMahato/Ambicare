import 'package:ambicare_service/screens/forgot_password/forgot_password.dart';
import 'package:ambicare_service/screens/main_screen.dart';
import 'package:ambicare_service/screens/splash_screen.dart';
import 'package:ambicare_service/services/database.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_password_field.dart';
import '../components/custom_text_field.dart';
import '../components/scroll_behaviour.dart';
import '../components/waiting_dialog.dart';
import '../main.dart';
import '../screens/signup_screen.dart';
import '../services/auth.dart';
import '../constants/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Signin extends StatefulWidget {
  static const String id = "/signin";
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late TextEditingController phoneNumberController;

  late TextEditingController passwordController;

  late GlobalKey<FormState> globalKey;

  Future<void> setCustomMarker() async {
    mapMarkerAmbulanceAvailable = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'images/marker-red.png');
    mapMarkerAmbulanceNotAvailable = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'images/not-available.png');
  }

  @override
  void initState() {
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: kWhite,
        body: Padding(
          padding: const EdgeInsets.only(
            // top: size.height * 0.1,
            left: 25.0,
            right: 25.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 50.0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.07,
                        ),
                        Image.asset("images/logo.png"),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Text(
                          "LOG IN",
                          textAlign: TextAlign.center,
                          style: kTextFieldLabelStyle.copyWith(
                            fontSize: 20.0,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: globalKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Text(
                                  "PHONE NUMBER",
                                  textAlign: TextAlign.center,
                                  style: kTextFieldLabelStyle.copyWith(
                                    fontSize: 14.3,
                                    fontFamily: "Ubuntu",
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              CustomTextField2(
                                controller: phoneNumberController,
                                isPhoneNumber: true,
                                icon: EvaIcons.phoneCallOutline,
                              ),
                              SizedBox(
                                height: size.height * 0.035,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Text(
                                  "PASSWORD",
                                  textAlign: TextAlign.center,
                                  style: kTextFieldLabelStyle.copyWith(
                                    fontSize: 14.3,
                                    fontFamily: "Ubuntu",
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              CustomPasswordField(
                                controller: passwordController,
                                icon: EvaIcons.lockOutline,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      navigatorKey.currentState!
                                          .pushNamed(ForgotPassword.id);
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: kLightRedColor.withOpacity(0.8),
                                        fontFamily: "Ubuntu",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              CustomButton(
                                borderRadius: 20.0,
                                onPressed: () async {
                                  if (globalKey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const WaitingDialog(
                                          title: "Authenticating"),
                                    );
                                    final body = {
                                      "phoneNumber":
                                          phoneNumberController.text.trim(),
                                      "password":
                                          passwordController.text.trim(),
                                    };
                                    final result =
                                        await Authentication.signIn(body);
                                    if (result! ~/ 100 != 2) {
                                      navigatorKey.currentState!.pop();
                                      return showSnackBar(
                                        context,
                                        "Invalid username or password.",
                                        kLightRedColor,
                                      );
                                    }
                                    allAmbulances =
                                        await Database.getAllAmbulances();

                                    if (result ~/ 100 == 2) {
                                      setCustomMarker();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!
                                          .pushNamedAndRemoveUntil(
                                              HomePage.id, (route) => false);
                                      showSnackBar(
                                        context,
                                        "Login successful",
                                        Colors.green,
                                      );
                                    } else if (result ~/ 100 == 4) {
                                      navigatorKey.currentState!.pop();
                                      showSnackBar(
                                          context,
                                          "Invalid username or password.",
                                          kLightRedColor);
                                    }
                                    //  else if (result ~/ 100 == 5) {
                                    //   navigatorKey.currentState!.pop();
                                    //   showSnackBar(
                                    //       context,
                                    //       "Couldnot login, please try again later.",
                                    //       Colors.red);
                                    // }
                                    else {
                                      navigatorKey.currentState!.pop();
                                      showSnackBar(
                                          context,
                                          "Couldnot login, please try again later.",
                                          kLightRedColor);
                                    }
                                  }
                                },
                                buttonContent: const Text(
                                  "LOG IN",
                                  style: kButtonContentTextStye,
                                ),
                                width: size.width * 0.75,
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account ?  ',
                                    style: kTextFieldLabelStyle.copyWith(
                                      fontSize: 16.0,
                                      fontFamily: "Ubuntu",
                                      color: kLightRedColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      navigatorKey.currentState!
                                          .pushNamed(Signup.id);
                                    },
                                    child: Text(
                                      'Register',
                                      style: kTextFieldLabelStyle.copyWith(
                                          fontFamily: "Ubuntu",
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: kDarkRedColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
