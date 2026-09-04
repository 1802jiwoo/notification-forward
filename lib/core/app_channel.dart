import 'package:flutter/services.dart';

class AppChannel {
  AppChannel._();
  static const MethodChannel instance = MethodChannel('com.bjw.smsforward');
}