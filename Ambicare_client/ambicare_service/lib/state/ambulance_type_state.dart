import 'package:flutter/cupertino.dart';

class AmbulanceTypeState extends ChangeNotifier {
  String ambulanceType = "Mobile ICU";

  changeState(String newType) {
    ambulanceType = newType;
    notifyListeners();
  }
}
