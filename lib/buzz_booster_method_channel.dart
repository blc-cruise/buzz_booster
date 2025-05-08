import 'dart:io';
import 'package:buzz_booster/buzz_booster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'buzz_booster_platform_interface.dart';

class MethodChannelBuzzBooster extends BuzzBoosterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('buzz_booster');

  @visibleForTesting
  final eventChannel = const EventChannel('buzz_booster/link');

  @override
  Future<void> setUser(User? user, ) async {
    return await methodChannel.invokeMethod<void>("setUser", {
      "userId": user?.userId,
      "optInMarketing": user?.optInMarketing,
      "properties": user?.properties,
    });
  }

  @override
  Future<void> init(
      {required String androidAppKey, required String iosAppKey}) async {
    return await methodChannel.invokeMethod<void>("init", {
      "androidAppKey": androidAppKey,
      "iosAppKey": iosAppKey,
    });
  }

    @override
  Future<bool> isInitialized() async {
    bool? result = await methodChannel.invokeMethod<bool?>("isInitialized", {});
    if ( result != null ) {
      return Future.value(result);
    } else {
      return Future.value(false);
    }
  }

  @override
  Future<void> sendEvent(
    String eventName,
    Map<String, Object>? eventValues,
  ) async {
    return await methodChannel.invokeMethod<void>("sendEvent", {
      "eventName": eventName,
      "eventValues": eventValues,
    });
  }

  @override
  Future<void> showInAppMessage() async {
    return await methodChannel.invokeMethod<void>("showInAppMessage", {});
  }

  @override
  Future<void> showHome() async {
    return await methodChannel.invokeMethod<void>("showHome", {});
  }

  @override
  Future<void> showPage(String pageId) async {
    return await methodChannel.invokeMethod<void>("showPage", {"pageId": pageId});
  }

  @override
  Future<void> setPushToken(String token) async {
    return await methodChannel.invokeMethod<void>("setPushToken", {"token": token});
  }

  @override
  Future<bool> isBuzzBoosterNotification(Map<String, dynamic> map) async {
    bool? result = await methodChannel.invokeMethod<bool?>("isBuzzBoosterNotification", {"map": map});
    if ( result != null ) {
      return Future.value(result);
    } else {
      return Future.value(false);
    }
  }

  @override
  Future<void> handleNotification(Map<String, dynamic> map) async {
    if (Platform.isAndroid) {
      return await methodChannel.invokeMethod<void>("handleNotification", {"map": map});
    } else {
      return await Future.value();
    }
  }

  @override
  Future<void> handleInitialMessage(Map<String, dynamic> data) async {
    if (Platform.isIOS) {
      return await methodChannel.invokeMethod<void>("handleInitialMessage", {"map": data});
    } else if (Platform.isAndroid) {
      bool? exists = await methodChannel.invokeMethod<bool?>("hasUnhandledNotificationClick", {});
      if (exists != null && exists) {
        return await methodChannel.invokeMethod<void>("handleNotificationClick", {});;
      }
    }
    return Future.value();
  }
  
  @override
  Future<void> handleOnMessageOpenedApp(Map<String, dynamic> data) async {
    if (Platform.isIOS) {
      return await methodChannel.invokeMethod<void>("handleInitialMessage", {"map": data});
    } 
    return Future.value();
  }

  Future<void> showNaverPayExchange() async {
    return await methodChannel.invokeMethod<void>("showNaverPayExchange", {});
  }

  Future<void> showCampaignWithId(String campaignId) async {
    return await methodChannel.invokeMethod<void>("showCampaignWithId", {
      "campaignId":campaignId
    });
  }

  @override
  Future<void> showCampaignWithType(CampaignType campaignType) async {
    return await methodChannel.invokeMethod<void>("showCampaignWithType", {
      "campaignType":campaignType.name
    });
  }

  @override
  Future<void> setTheme(BuzzBoosterTheme theme) async {
    return await methodChannel.invokeMethod<void>("setTheme", {
      "theme":theme.name
    });
  }

  @override
  late final Stream<MapEntry<NativeEvent, dynamic>> eventStream = eventChannel
      .receiveBroadcastStream()
      .map<MapEntry<NativeEvent, dynamic>>((dynamic event) {
        String eventName = event["event"] as String;
        if (eventName == "optInMarketingCampaignMoveButtonClicked") {
          return MapEntry(NativeEvent.optInMarketingCampaignMoveButtonClicked, null);
        } else if (eventName == "userEventDidOccur") {
          return MapEntry(NativeEvent.userEventDidOccur, {
            "userEventName": event["userEventName"],
            "userEventValues": event["userEventValues"] != null ? new Map<String, dynamic>.from(event["userEventValues"]) : null
          });
        } else {
          return MapEntry(NativeEvent.unknown, null);
        }
      });

  @override
  Future<void> postJavaScriptMessage(String message) async {
    return await methodChannel.invokeMethod<void>("postJavaScriptMessage", {"message": message});
  }
}

enum NativeEvent {
  optInMarketingCampaignMoveButtonClicked,
  userEventDidOccur,
  unknown
}