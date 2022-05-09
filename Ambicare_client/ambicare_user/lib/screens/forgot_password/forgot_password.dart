import 'package:ambicare_user/components/custom_button.dart';
import 'package:ambicare_user/components/custom_text_field.dart';
import 'package:ambicare_user/components/waiting_dialog.dart';
import 'package:ambicare_user/constants/constants.dart';
import 'package:ambicare_user/main.dart';
import 'package:ambicare_user/screens/forgot_password/phone_verification.dart';
import 'package:ambicare_user/screens/phone_verification.dart';
import 'package:ambicare_user/screens/signup_screen.dart';
import 'package:ambicare_user/services/otp_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgotPassword';

  const ForgotPassword({Key? key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textController = Get.find<TextController>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: size.height * 0.25,
                    child: Center(child: Image.asset('images/logo.png'))),
                const Text(
                  'Reset Password !',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: kDarkRedColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                const Text(
                  'Please Enter Your Phone Number To',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Montserrat",
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                const Text(
                  'Recieve a Verification Code ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                CustomTextField(
                  controller: phoneNumberController,
                  icon: EvaIcons.phoneCallOutline,
                  isPhoneNumber: true,
                ),
                SizedBox(
                  height: size.height * 0.09,
                ),
                CustomButton(
                  buttonContent: Text(
                    "CONFIRM",
                    style: kButtonContentTextStye.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  width: double.infinity,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WaitingDialog(title: "Sending OTP"),
                      );
                      final result = await OtpServices.sendOtp(
                          {"phoneNumber": phoneNumberController.text.trim()});
                      if (result.isEmpty) {
                        navigatorKey.currentState!.pop();
                        showSnackBar(
                          context,
                          "Verification code couldnot be sent",
                          kLightRedColor,
                        );
                      } else {
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pushNamed(
                          PhoneVerificationForPassword.id,
                          arguments: {
                            "phoneNumber": phoneNumberController.text.trim(),
                            "sid": result["service_sid"]
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
