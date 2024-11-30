import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/Const/app_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../main.dart';

class ApiServices {
  Future<Response?> getApiCall(String apiUrl) async {
    bool? hasInternet = await checkInternet();
    if (hasInternet!) {
      var headers1 = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer '
      };

      final response = await get(Uri.parse(apiUrl), headers: headers1);

      return response;
    } else {
      SnackBar snackBar = const SnackBar(
        content: Text(AppString.checkInternet),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
    }
    return null;
    // return response;
  }
}

Future<bool?> checkInternet() async {
  try {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  } on SocketException {
    return false;
  }
}
