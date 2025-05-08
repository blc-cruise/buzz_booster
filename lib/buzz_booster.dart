import 'package:buzz_booster/buzz_booster_method_channel.dart';
import 'buzz_booster_platform_interface.dart';

class BuzzBooster {
  Function()? _optInMarketingCampaignMoveButtonClickedCallback = null;
  set optInMarketingCampaignMoveButtonClickedCallback(Function()? callback){
    _optInMarketingCampaignMoveButtonClickedCallback = callback;
  }

  Function(String, Map<String, dynamic>?)? _userEventChannel = null;
  set userEventChannel(Function(String, Map<String, dynamic>?)? userEventChannel){
    _userEventChannel = userEventChannel;
  }

  BuzzBooster() {
    BuzzBoosterPlatform.instance.eventStream.listen((event) {
      if (event.key == NativeEvent.optInMarketingCampaignMoveButtonClicked) {
        _optInMarketingCampaignMoveButtonClickedCallback?.call();
      } else if (event.key == NativeEvent.userEventDidOccur) {
        _userEventChannel?.call(event.value["userEventName"], event.value["userEventValues"]);
      }
    });
  }

  Future<void> setUser(User? user, ) {
    return BuzzBoosterPlatform.instance.setUser(user, );
  }

  Future<void> init(
      {required String androidAppKey, required String iosAppKey}) {
    return BuzzBoosterPlatform.instance
        .init(androidAppKey: androidAppKey, iosAppKey: iosAppKey);
  }

  Future<bool> isInitialized() {
    return BuzzBoosterPlatform.instance.isInitialized();
  }

  Future<void> sendEvent(
    String eventName,
    Map<String, Object>? eventValues,
  ) {
    eventValues?.forEach((key, value) {
      assert(
        value is String || value is num || value is bool,
        "'string' OR 'number' OR 'bool' must be set as the value of the parameter: $key",
      );
    });
    return BuzzBoosterPlatform.instance.sendEvent(
      eventName,
      eventValues,
    );
  }

  Future<void> showInAppMessage() {
    return BuzzBoosterPlatform.instance.showInAppMessage();
  }

  Future<void> showHome() {
    return BuzzBoosterPlatform.instance.showHome();
  }

  Future<void> showPage(String pageId) {
    return BuzzBoosterPlatform.instance.showPage(pageId);
  }

  Future<void> showNaverPayExchange() {
    return BuzzBoosterPlatform.instance.showNaverPayExchange();
  }

  Future<void> setPushToken(String token) {
    return BuzzBoosterPlatform.instance.setPushToken(token);
  }

  Future<bool> isBuzzBoosterNotification(Map<String, dynamic> map) {
    return BuzzBoosterPlatform.instance.isBuzzBoosterNotification(map);
  }

  Future<void> handleNotification(Map<String, dynamic> map) {
    return BuzzBoosterPlatform.instance.handleNotification(map);
  }
  
  Future<void> showCampaignWithId(String campaignId) {
    return BuzzBoosterPlatform.instance.showCampaignWithId(campaignId);
  }

  Future<void> showCampaignWithType(CampaignType campaignType) {
    return BuzzBoosterPlatform.instance.showCampaignWithType(campaignType);
  }

  Future<void> setTheme(BuzzBoosterTheme theme) {
    return BuzzBoosterPlatform.instance.setTheme(theme);
  }

  Future<void> handleInitialMessage(Map<String, dynamic> data) {
    return BuzzBoosterPlatform.instance.handleInitialMessage(data);
  }

  Future<void> handleOnMessageOpenedApp(Map<String, dynamic> data) {
    return BuzzBoosterPlatform.instance.handleOnMessageOpenedApp(data);
  }
  
  Future<void> postJavaScriptMessage(String message) {
    return BuzzBoosterPlatform.instance.postJavaScriptMessage(message);
  }
}

class UserBuilder {
  final String userId;
  bool? optInMarketing;
  Map<String, Object> properties = {};
  
  UserBuilder(this.userId);

  UserBuilder setOptInMarketing(bool optInMarketing) {
    this.optInMarketing = optInMarketing;
    return this;
  }

  UserBuilder addProperty(String key, Object value) {
    assert(
      value is String || value is num || value is bool,
      "'string' OR 'number' OR 'bool' must be set as the value of the parameter: $key",
    );
    properties[key] = value;
    return this;
  }

  User build() {
    return User._builder(this);
  }
}

class User {
  final String userId;
  final bool? optInMarketing;
  final Map<String, Object> properties;

  User._builder(UserBuilder builder) :
    userId = builder.userId,
    optInMarketing = builder.optInMarketing,
    properties = builder.properties;
}

enum CampaignType {
  attendance,
  referral,
  optInMarketing,
  scratchLottery,
  roulette
}

enum BuzzBoosterTheme {
  light,
  dark,
  system
}
