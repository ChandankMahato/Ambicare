import 'package:ambicare_driver/screens/forgot_password/forgot_password.dart';
import 'package:ambicare_driver/screens/main_screen.dart';
import 'package:ambicare_driver/screens/main_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_password_field.dart';
import '../components/custom_text_field.dart';
import '../components/scroll_behaviour.dart';
import '../components/waiting_dialog.dart';
import '../main.dart';
import '../services/auth.dart';
import '../constants/constants.dart';

class Signin extends StatefulWidget {
  static const String id = "/signin";
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController registrationController;
  late GlobalKey<FormState> globalKey;

  @override
  void initState() {
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    registrationController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    registrationController.dispose();
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
                                  top: 10.0,
                                ),
                                child: Text(
                                  "REGISTRATION NUMBER",
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
                                controller: registrationController,
                                icon: EvaIcons.carOutline,
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
                                      "registrationNumber":
                                          registrationController.text.trim(),
                                      "phoneNumber":
                                          phoneNumberController.text.trim(),
                                      "password":
                                          passwordController.text.trim(),
                                    };
                                    final result =
                                        await Authentication.signIn(body);
                                    if (result! ~/ 100 == 2) {
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
                                        kLightRedColor,
                                      );
                                    } else {
                                      navigatorKey.currentState!.pop();
                                      showSnackBar(
                                        context,
                                        "Couldnot login, please try again later.",
                                        kLightRedColor,
                                      );
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
