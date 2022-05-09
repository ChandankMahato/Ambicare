import 'package:ambicare_user/screens/phone_verification.dart';
import 'package:ambicare_user/services/auth.dart';
import 'package:ambicare_user/services/database.dart';
import 'package:ambicare_user/services/otp_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../components/custom_button.dart';
import '../components/custom_password_field.dart';
import '../components/custom_text_field.dart';
import '../components/scroll_behaviour.dart';
import '../components/waiting_dialog.dart';
import '../constants/constants.dart';
import '../main.dart';
import '../screens/signin_screen.dart';

class Signup extends StatefulWidget {
  static const String id = "/signup";
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late GlobalKey<FormState> globalKey;
  late GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
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
            // Image.asset("images/logo.png"),
            // Text(
            //   "Ambicare",
            //   style: kAppName.copyWith(
            //     fontSize: 50,
            //     fontFamily: "Ubuntu",
            //   ),
            // ),
            // SizedBox(
            //   height: size.height * 0.03,
            // ),
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
                        "CREATE NEW ACCOUNT",
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
                                "USERNAME",
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
                            CustomTextField(
                              controller: usernameController,
                              icon: EvaIcons.personOutline,
                            ),
                            SizedBox(
                              height: size.height * 0.035,
                            ),
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
                            CustomTextField(
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
                                "EMAIL",
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
                            CustomTextField(
                              controller: emailController,
                              icon: EvaIcons.emailOutline,
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
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            CustomButton(
                              borderRadius: 20.0,
                              onPressed: () async {
                                if (globalKey.currentState!.validate()) {
                                  // TODO: show dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => const WaitingDialog(
                                        title: "Autheticating"),
                                  );
                                  final result = await Database.userExists(
                                      phoneNumberController.text.trim());
                                  if (result! ~/ 100 != 2) {
                                    navigatorKey.currentState!.pop();
                                    return showSnackBar(
                                      context,
                                      "User already exists",
                                      Colors.red,
                                    );
                                  }
                                  final otpResult = await OtpServices.sendOtp({
                                    "phoneNumber":
                                        phoneNumberController.text.trim()
                                  });
                                  if (otpResult.isEmpty) {
                                    showSnackBar(
                                      context,
                                      "Verification code couldnot be sent",
                                      kLightRedColor,
                                    );
                                  } else {
                                    navigatorKey.currentState!.pushNamed(
                                      PhoneVerification.id,
                                      arguments: {
                                        "email": emailController.text.trim(),
                                        "password":
                                            passwordController.text.trim(),
                                        "name": usernameController.text.trim(),
                                        "phoneNumber":
                                            phoneNumberController.text.trim(),
                                        "sid": otpResult["service_sid"]
                                      },
                                    );
                                  }

                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => const WaitingDialog(
                                  //       title: "Authenticating"),
                                  // );
                                  // final result = await Database.userExists(
                                  //     phoneNumberController.text.trim());
                                  // print(result);
                                  // if (result! ~/ 100 != 2) {
                                  //   navigatorKey.currentState!.pop();
                                  //   return showSnackBar(
                                  //     context,
                                  //     "User already exists",
                                  //     Colors.red,
                                  //   );
                                  // }
                                  // final body = {
                                  //   "name": usernameController.text.trim(),
                                  //   "email": emailController.text.trim(),
                                  //   "phoneNumber":
                                  //       phoneNumberController.text.trim(),
                                  //   "password": passwordController.text.trim(),
                                  // };
                                  // print(body);
                                  // final signUpresult =
                                  //     await Authentication.signUp(body);
                                  // if (signUpresult! ~/ 100 == 2) {
                                  //   navigatorKey.currentState!.pop();
                                  //   navigatorKey.currentState!
                                  //       .pushNamedAndRemoveUntil(
                                  //           Signin.id, (route) => false);
                                  //   showSnackBar(
                                  //       context,
                                  //       "Account successfully created",
                                  //       Colors.green);
                                  // } else if (signUpresult ~/ 100 == 4) {
                                  //   navigatorKey.currentState!.pop();
                                  //   showSnackBar(context, "User already exists",
                                  //       kLightRedColor);
                                  // } else if (signUpresult ~/ 100 == 5) {
                                  //   navigatorKey.currentState!.pop();
                                  //   showSnackBar(
                                  //       context,
                                  //       "Account could not be created",
                                  //       kLightRedColor);
                                  // } else {
                                  //   navigatorKey.currentState!.pop();
                                  //   navigatorKey.currentState!
                                  //       .pushNamedAndRemoveUntil(
                                  //           Signin.id, (route) => false);
                                  //   showSnackBar(
                                  //       context,
                                  //       "Account successfully created",
                                  //       Colors.green);
                                  // }
                                }
                              },
                              buttonContent: const Text(
                                "REGISTER",
                                style: kButtonContentTextStye,
                              ),
                              width: size.width * 0.75,
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?  ',
                            style: kTextFieldLabelStyle.copyWith(
                              fontSize: 16.0,
                              fontFamily: "Ubuntu",
                              color: kLightRedColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigatorKey.currentState!
                                  .pushNamedAndRemoveUntil(
                                      Signin.id, (route) => false);
                            },
                            child: Text(
                              'Sign in',
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
              ),
            ))
          ],
        ),
      ),
    );
  }
}

showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: kWhite,
        fontSize: 16.0,
      ),
    ),
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(20.0),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
