import 'package:demo_app/models/app_list.dart';
import 'package:demo_app/models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkManager {
  Future<void> getAppList(BuildContext context) async {
    List<AppModel> list = [];
    for( var i = 0 ; i < 5; i++ ) {
      list.add(AppModel("Test $i"));
    }
    var model = context.read<AppList>();
    await Future.delayed(const Duration(seconds: 1));
    model.set(list);
  }
}