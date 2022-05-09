import 'package:ambicare_service/constants/constants.dart';
import 'package:flutter/cupertino.dart';

class FilterStatusColourState extends ChangeNotifier {
  Color? allColour = kLightRedColor;
  Color? onlineColour = kDarkRedColor;
  Color? offlineColour = kDarkRedColor;

  changeOnlineState() {
    allColour = kDarkRedColor;
    offlineColour = kDarkRedColor;
    onlineColour = kLightRedColor;
    notifyListeners();
  }

  changeOfflineState() {
    allColour = kDarkRedColor;
    onlineColour = kDarkRedColor;
    offlineColour = kLightRedColor;
    notifyListeners();
  }

  changeAllState() {
    offlineColour = kDarkRedColor;
    onlineColour = kDarkRedColor;
    allColour = kLightRedColor;
    notifyListeners();
  }
}
