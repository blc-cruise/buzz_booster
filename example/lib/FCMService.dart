import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

class FCMService {
  Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("token:" + token);
    } else {
      print("no token");
    }
    return Future.value(token);
  }

  Future<void> requestPermission() async {
    // iOS: sound, badge and alert
    // https://github.com/Baseflow/flutter-permission-handler/blob/978dbebc195a3d23c18b067a6357d7cdd6e729f6/permission_handler_apple/ios/Classes/strategies/NotificationPermissionStrategy.m#L37
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print('User granted permission');
    } else if (status.isDenied) {
      print('User declined permission');
    } else if (status.isPermanentlyDenied) {
      print('User declined permission permanently');
    }
    return Future.value();
  }
}
