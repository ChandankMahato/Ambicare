import 'package:flutter/cupertino.dart';

class FilterStatusState extends ChangeNotifier {
  String? filterStatus = "All";

  changeState(String newValue) {
    filterStatus = newValue;
    notifyListeners();
  }
}
