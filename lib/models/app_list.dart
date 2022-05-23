import 'package:flutter/material.dart';

import 'app_model.dart';

class AppList with ChangeNotifier  {
  List<AppModel> itemNames = [
  ];
  void set(List<AppModel> itemNames) {
    this.itemNames = itemNames;
    notifyListeners();
  }
}