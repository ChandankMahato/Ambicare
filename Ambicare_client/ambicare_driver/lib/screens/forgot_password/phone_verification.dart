import 'package:ambicare_driver/components/custom_button.dart';
import 'package:ambicare_driver/components/waiting_dialog.dart';
import 'package:ambicare_driver/constants/constants.dart';
import 'package:ambicare_driver/main.dart';
import 'package:ambicare_driver/screens/forgot_password/change_password.dart';
import 'package:ambicare_driver/services/otp_services.dart';
import 'package:ambicare_driver/state/phone_verification_state.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PhoneVerificationForPassword extends StatefulWidget {
  static const String id = '/phoneVerificationForPassword';
  final Map<String, dynamic>? args;

  const PhoneVerificationForPassword({this.args, Key? key}) : super(key: key);

  @override
  State<PhoneVerificationForPassword> createState() =>
      _PhoneVerificationForPasswordState();
}

class _PhoneVerificationForPasswordState
    extends State<PhoneVerificationForPassword> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50.0,
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
                          const WaitingDialog(title: "Sending OTP"),
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
                      navigatorKey.currentState!.pop();
                      navigatorKey.currentState!.pushReplacementNamed(
                        ChangePassword.id,
                        arguments: widget.args,
                      );
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
