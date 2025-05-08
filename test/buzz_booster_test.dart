import 'package:flutter_test/flutter_test.dart';
import 'package:buzz_booster/buzz_booster.dart';
import 'package:buzz_booster/buzz_booster_platform_interface.dart';
import 'package:buzz_booster/buzz_booster_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBuzzBoosterPlatform
    with MockPlatformInterfaceMixin
    implements BuzzBoosterPlatform {
  @override
  Future<void> setUser(User? user) => Future.value();

  @override
  Future<void> init({required String androidAppKey, required String iosAppKey}) => Future.value();

  @override
  Future<void> sendEvent(String eventName, Map<String, Object>? eventValues) =>
      Future.value();

  @override
  Future<void> showInAppMessage() => Future.value();

  @override
  Future<void> showHome() => Future.value();

  @override
  Future<void> showCampaignWithId(String campaignId) => Future.value();

  @override
  Future<void> showCampaignWithType(CampaignType campaignType) => Future.value();

  @override
  Future<void> showPage(String pageId) => Future.value();

  @override
  Future<void> setPushToken(String token) => Future.value();

  @override
  Future<bool> isBuzzBoosterNotification(Map<String, dynamic> map) => Future.value(true);

  @override
  Future<void> handleNotification(Map<String, dynamic> map) => Future.value();
  
  @override
  Future<void> handleInitialMessage(Map<String, dynamic> data) => Future.value();

  @override
  Future<void> showNaverPayExchange() => Future.value();

  @override
  Future<void> handleOnMessageOpenedApp(Map<String, dynamic> data) => Future.value();

  @override
  Future<void> postJavaScriptMessage(String message) => Future.value();

  @override
  Stream<MapEntry<NativeEvent, dynamic>> get eventStream => Stream.empty();

  @override
  Stream<void> get optInMarketinCampaignMoveButtonClickedEventStream => Stream.empty();
  
  @override
  Future<void> setTheme(BuzzBoosterTheme theme) => Future.value();
}

void main() {
  final BuzzBoosterPlatform initialPlatform = BuzzBoosterPlatform.instance;

  test('$MethodChannelBuzzBooster is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBuzzBooster>());
  });

  test('setUser', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;
  
    User user = UserBuilder("Damon")
    .setOptInMarketing(true)
    .build();
    await buzzBoosterPlugin.setUser(user);
    await buzzBoosterPlugin.setUser(null);
  });

  test('init', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;

    await buzzBoosterPlugin.init(
        androidAppKey: "androidAppKey", iosAppKey: "iosAppKey");
  });

  test('sendEvent', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;

    await buzzBoosterPlugin
        .sendEvent("eventName", {"eventValuesKey1": "eventValuesValue1"});
  });

  test('sendEventWithNoValues', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;

    await buzzBoosterPlugin.sendEvent("eventName", null);
  });

  test('showInAppMessage', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;

    await buzzBoosterPlugin.showInAppMessage();
  });

  test('showHome', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;

    await buzzBoosterPlugin.showHome();
  });

  test('showCampaignWithId', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;
  
    await buzzBoosterPlugin.showCampaignWithId("campaignId");
  });

  test('showCampaignWithType', () async {
    BuzzBooster buzzBoosterPlugin = BuzzBooster();
    MockBuzzBoosterPlatform fakePlatform = MockBuzzBoosterPlatform();
    BuzzBoosterPlatform.instance = fakePlatform;
  
    await buzzBoosterPlugin.showCampaignWithType(CampaignType.attendance);
  });
}
