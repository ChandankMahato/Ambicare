import 'package:ambicare_driver/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PhoneVerificationSate extends ChangeNotifier {
  String pin = "";
  bool error = false;
  var defaultPinTheme = PinTheme(
    width: 40.0,
    height: 40.0,
    textStyle: const TextStyle(
      fontSize: 20,
      color: kLightRedColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: kWhite,
      border: Border.all(color: kGreyColor),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  Widget errorMessage = Container();

  onError(String message) {
    errorMessage = Padding(
      padding: const EdgeInsets.only(left: 4.5),
      child: Text(
        message,
        style: const TextStyle(
          color: kLightRedColor,
          fontSize: 16.5,
        ),
      ),
    );
    defaultPinTheme = PinTheme(
      width: 40.0,
      height: 40.0,
      textStyle: const TextStyle(
        fontSize: 20,
        color: kLightRedColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: kLightRedColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: kWhite,
      ),
    );
    error = true;
    notifyListeners();
  }

  reset() {
    defaultPinTheme = PinTheme(
      width: 40.0,
      height: 40.0,
      textStyle: const TextStyle(
        fontSize: 20,
        color: kLightRedColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: kWhite,
        border: Border.all(color: kGreyColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    errorMessage = Container();
    error = false;
    notifyListeners();
  }
}
