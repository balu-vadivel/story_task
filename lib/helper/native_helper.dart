import 'package:flutter/services.dart';

const platform = MethodChannel('strory.task');

Future<dynamic> getAndroidVersion() async {
  return await platform.invokeMethod('getVersion');
}

Future<dynamic> saveToDocuments(String filePath) async {
  return await platform.invokeMethod('saveToDocuments', filePath);
}
