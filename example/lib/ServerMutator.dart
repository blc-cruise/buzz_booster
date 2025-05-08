import 'dart:async';
import 'package:flutter/services.dart';

enum Environment { Production, Staging, StagingQA, Dev, Local }

class ServerMutator {
  ServerMutator() {}
  Future<void> changeEnvironment(Environment environment) async {
    try {
      await MethodChannel('com.buzzvil.dev/booster')
          .invokeMethod('changeEnvironment', {"environment": environment.name});
    } catch (e) {
      print("fail to change");
    }
    return Future.value();
  }
}
