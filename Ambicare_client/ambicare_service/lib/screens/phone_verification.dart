import 'package:ambicare_service/components/custom_button.dart';
import 'package:ambicare_service/components/waiting_dialog.dart';
import 'package:ambicare_service/constants/constants.dart';
import 'package:ambicare_service/main.dart';
import 'package:ambicare_service/screens/signin_screen.dart';
import 'package:ambicare_service/screens/signup_screen.dart';
import 'package:ambicare_service/services/auth.dart';
import 'package:ambicare_service/services/otp_services.dart';
import 'package:ambicare_service/state/phone_verification_state.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PhoneVerification extends StatefulWidget {
  static const String id = '/phoneverification';
  final Map<String, dynamic>? args;

  const PhoneVerification({this.args, Key? key}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        foregroundColor: kLightRedColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 30.0,
            right: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),
              const SizedBox(
                height: 40.0,
              ),
              const Text(
                "Verify Mobile Number",
                style: TextStyle(
                  color: kLightRedColor,
                  fontSize: 20.0,
                  fontFamily: ubuntu,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "OTP sent to +977-${widget.args!["phoneNumber"]}",
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 16.0,
                  fontFamily: ubuntu,
                  wordSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Please enter the OTP you just received.",
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 14.0,
                  fontFamily: ubuntu,
                  wordSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              getPinPut(),
              Provider.of<PhoneVerificationSate>(context, listen: true).error
                  ? const SizedBox(
                      height: 10.0,
                    )
                  : Container(),
              Provider.of<PhoneVerificationSate>(context, listen: true).error
                  ? Provider.of<PhoneVerificationSate>(context, listen: false)
                      .errorMessage
                  : const SizedBox(
                      height: 5.0,
                    ),
              const SizedBox(
                height: 50.0,
              ),
              CustomButton(
                onPressed: () async {
                  final userPin =
                      Provider.of<PhoneVerificationSate>(context, listen: false)
                          .pin;
                  if (userPin == "") {
                    Provider.of<PhoneVerificationSate>(context, listen: false)
                        .onError("Required");
                  } else if (userPin.length != 6 ||
                      double.tryParse(userPin) == null) {
                    Provider.of<PhoneVerificationSate>(context, listen: false)
                        .onError("Invalid pin");
                  } else {
                    //TODO: check pin
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const WaitingDialog(title: "Autheticating"),
                    );
                    final body = {
                      "phoneNumber": widget.args!["phoneNumber"],
                      "code": Provider.of<PhoneVerificationSate>(context,
                              listen: false)
                          .pin,
                      "sid": widget.args!["sid"],
                    };
                    final result = await OtpServices.verifyOtp(body);
                    if (result.isEmpty) {
                      navigatorKey.currentState!.pop();
                      Provider.of<PhoneVerificationSate>(context, listen: false)
                          .onError("Incorrect pin");
                    } else {
                      final signupBody = {
                        "phoneNumber": widget.args!["phoneNumber"],
                        "name": widget.args!["name"],
                        "address": widget.args!["address"],
                        "password": widget.args!["password"],
                      };
                      final signUpresult =
                          await Authentication.signUp(signupBody);
                      if (signUpresult! ~/ 100 == 2) {
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pushNamedAndRemoveUntil(
                            Signin.id, (route) => false);
                        showSnackBar(context, "Account successfully created",
                            Colors.green);
                      } else if (signUpresult ~/ 100 == 4) {
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pushNamedAndRemoveUntil(
                            Signin.id, (route) => false);
                        showSnackBar(
                            context, "User already exists", kLightRedColor);
                      } else if (signUpresult ~/ 100 == 5) {
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pushNamedAndRemoveUntil(
                            Signin.id, (route) => false);
                        showSnackBar(context, "Account could not be created",
                            kLightRedColor);
                      }
                    }
                  }
                },
                width: double.infinity,
                buttonColor: kLightRedColor,
                borderRadius: 10.0,
                buttonContent: Text(
                  "VERIFY",
                  style: kButtonContentTextStye.copyWith(
                    color: kWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getPinPut() {
    final defaultPinTheme =
        Provider.of<PhoneVerificationSate>(context, listen: true)
            .defaultPinTheme;

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: kLightRedColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: kLightRedColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: kWhite,
      ),
    );

    return Pinput(
      length: 6,
      onTap: () {
        Provider.of<PhoneVerificationSate>(context, listen: false).reset();
      },
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      keyboardType: TextInputType.number,
      useNativeKeyboard: true,
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      closeKeyboardWhenCompleted: true,
      onChanged: (value) {
        Provider.of<PhoneVerificationSate>(context, listen: false).pin = value;
      },
      showCursor: false,
    );
  }
}
