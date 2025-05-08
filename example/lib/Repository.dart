import 'dart:convert';
import 'dart:io';
import 'package:buzz_booster/buzz_booster.dart';
import 'package:buzz_booster_example/ServerMutator.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Partner.dart';
import 'package:flutter/services.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

const String defaultAndroidAppKey = "307117684877774";
const String defaultiosAppKey = "279753136766115";
const String androidAppKeyKey = "androidAppKey";
const String androidAppKeyListKey = "androidAppKeyList";
const String iosAppKeyKey = "iosAppKey";
const String iosAppKeyListKey = "iosAppKeyList";
const String userIdKey = "userIdKey";
const String serverEnvironmentKey = "getServerEnvironmentKey";
const String themeKey = "themeKey";
const String isOptInMarketingKey = "isOptInMarketingKey";

class Repository {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getAppKey() async {
    if (Platform.isAndroid) {
      return getAndroidAppKey();
    } else {
      return getiOSAppKey();
    }
  }

  Future<bool> getIsOptInMarketing() async {
    final SharedPreferences prefs = await _prefs;
    return Future.value(prefs.getBool(isOptInMarketingKey) ?? false);
  }

  Future<void> saveIsOptInMarketing(bool isOptInMarketing) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(isOptInMarketingKey, isOptInMarketing);
  }

  Future<Environment> getServerEnvironment() async {
    final SharedPreferences prefs = await _prefs;
    final string = prefs.getString(serverEnvironmentKey);
    if (string == null) {
      return Future.value(Environment.Production);
    } else {
      final env = Environment.values
          .firstWhere((element) => element.toString() == string);
      return Future.value(env);
    }
  }

  Future<void> saveServerEnvironment(Environment environment) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(serverEnvironmentKey, environment.toString());
  }

  Future<BuzzBoosterTheme> getTheme() async {
    final SharedPreferences prefs = await _prefs;
    final string = prefs.getString(themeKey);
    if (string == null) {
      return Future.value(BuzzBoosterTheme.system);
    } else {
      final theme = BuzzBoosterTheme.values
          .firstWhere((element) => element.toString() == string);
      return Future.value(theme);
    }
  }

  Future<void> saveTheme(BuzzBoosterTheme theme) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(themeKey, theme.toString());
  }

  Future<List<Partner>> getAppKeys() async {
    String url;
    Environment env = await getServerEnvironment();
    switch (env) {
      case Environment.Dev:
        url = "https://api-dev.buzzvil.com/buzzbooster/sdk/dev/app-keys";
        break;
      case Environment.Staging:
        url = "https://api-staging.buzzvil.com/buzzbooster/sdk/dev/app-keys";
        break;
      case Environment.StagingQA:
        url = "https://api-stagingqa.buzzvil.com/buzzbooster/sdk/dev/app-keys";
        break;
      case Environment.Local:
        url = "http://localhost/sdk/dev/app-keys";
        break;
      default:
        url = "https://api-staging.buzzvil.com/buzzbooster/sdk/dev/app-keys";
        break;
    }
    final response = await http.get(Uri.parse(url));
    final body = utf8.decode(response.bodyBytes);
    return (jsonDecode(body) as List)
        .map((value) => Partner.fromJson(value))
        .toList();
  }

  Future<String> getAndroidAppKey() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(androidAppKeyKey) ?? defaultAndroidAppKey;
  }

  Future<String> getiOSAppKey() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(iosAppKeyKey) ?? defaultiosAppKey;
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(userIdKey) ?? "Damon";
  }

  Future<void> saveAppKey(String appKey, String userId) async {
    final SharedPreferences prefs = await _prefs;
    if (Platform.isAndroid) {
      prefs.setString(androidAppKeyKey, appKey);
    } else {
      prefs.setString(iosAppKeyKey, appKey);
    }
    prefs.setString(userIdKey, userId);
  }

  Future<void> clearCursor(String appKey) async {
    try {
      await MethodChannel('com.buzzvil.dev/booster')
          .invokeMethod('clearCursor', {"appKey": appKey});
    } catch (e) {
      print("fail to change");
    }
    return Future.value();
  }

  Future<String> getSdkVersion() async {
    String result = await MethodChannel('com.buzzvil.dev/booster')
        .invokeMethod('getVersionName');
    return result;
  }
}
