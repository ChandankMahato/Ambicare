import 'package:flutter/cupertino.dart';

class FilterTypeState extends ChangeNotifier {
  String? filterType = "All";

  changeState(String newValue) {
    filterType = newValue;
    notifyListeners();
  }
}
