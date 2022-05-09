import 'package:ambicare_service/constants/constants.dart';
import 'package:flutter/cupertino.dart';

class FilterTypeColourState extends ChangeNotifier {
  Color? allColour = kLightRedColor;
  Color? mobileICUColour = kDarkRedColor;
  Color? basicLifeSupportColour = kDarkRedColor;
  Color? multipleVictimColour = kDarkRedColor;
  Color? neonatalColour = kDarkRedColor;
  Color? isloationColour = kDarkRedColor;

  changeAllState() {
    mobileICUColour = kDarkRedColor;
    basicLifeSupportColour = kDarkRedColor;
    multipleVictimColour = kDarkRedColor;
    neonatalColour = kDarkRedColor;
    isloationColour = kDarkRedColor;
    allColour = kLightRedColor;
    notifyListeners();
  }

  changeMobileICUState() {
    allColour = kDarkRedColor;
    basicLifeSupportColour = kDarkRedColor;
    multipleVictimColour = kDarkRedColor;
    neonatalColour = kDarkRedColor;
    isloationColour = kDarkRedColor;
    mobileICUColour = kLightRedColor;
    notifyListeners();
  }

  changeBasicLifeSupportState() {
    allColour = kDarkRedColor;
    mobileICUColour = kDarkRedColor;
    multipleVictimColour = kDarkRedColor;
    neonatalColour = kDarkRedColor;
    isloationColour = kDarkRedColor;
    basicLifeSupportColour = kLightRedColor;
    notifyListeners();
  }

  changeMultipleVictimState() {
    allColour = kDarkRedColor;
    mobileICUColour = kDarkRedColor;
    neonatalColour = kDarkRedColor;
    isloationColour = kDarkRedColor;
    basicLifeSupportColour = kDarkRedColor;
    multipleVictimColour = kLightRedColor;
    notifyListeners();
  }

  changeNeonatalState() {
    allColour = kDarkRedColor;
    mobileICUColour = kDarkRedColor;
    multipleVictimColour = kDarkRedColor;
    isloationColour = kDarkRedColor;
    basicLifeSupportColour = kDarkRedColor;
    neonatalColour = kLightRedColor;
    notifyListeners();
  }

  changeIsolationState() {
    allColour = kDarkRedColor;
    mobileICUColour = kDarkRedColor;
    multipleVictimColour = kDarkRedColor;
    neonatalColour = kDarkRedColor;
    basicLifeSupportColour = kDarkRedColor;
    isloationColour = kLightRedColor;
    notifyListeners();
  }
}
