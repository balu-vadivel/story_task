import 'package:demo_status/helper/native_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<void> downloadFiles(String imgUrl, BuildContext context) async {
  Map<Permission, PermissionStatus>? statuses;

  bool needScopeStorage = Platform.isAndroid && await getAndroidVersion() > 28;
  if (!needScopeStorage) {
    statuses = await [Permission.storage].request();
  }
  if (needScopeStorage || statuses![Permission.storage]!.isGranted) {
    var dir = needScopeStorage
        ? await getApplicationSupportDirectory()
        : await getExternalStorageDirectory();
    if (dir != null) {
      String savename = imgUrl.split("/").last;
      String savePath = "${dir.path}/$savename";
      debugLog(savePath);

      try {
        await Dio().download(imgUrl.toString(), savePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            if (kDebugMode) {
              debugLog("${(received / total * 100).toStringAsFixed(0)}%");
            }
          }
        });
        if (needScopeStorage) saveToDocuments(savename);
        showToast(context, 'File Downloaded');
      } on DioError catch (e) {
        debugLog(e.message);
      }
    }
  }
}

void showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      action:
          SnackBarAction(label: 'X', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

void debugLog(dynamic message) {
  if (kDebugMode) {
    print(message.toString());
  }
}
