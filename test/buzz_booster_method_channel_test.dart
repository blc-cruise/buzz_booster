import 'package:buzz_booster/buzz_booster.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buzz_booster/buzz_booster_method_channel.dart';

void main() {
  MethodChannelBuzzBooster platform = MethodChannelBuzzBooster();
  const MethodChannel channel = MethodChannel('buzz_booster');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('setUser', () async {
    User user = UserBuilder("userId").build();
    await platform.setUser(user);
    await platform.setUser(null);
  });

  test('init', () async {
    await platform.init(androidAppKey: "androidAppKey", iosAppKey: "iosAppKey");
  });

  test('sendEvent', () async {
    await platform
        .sendEvent("eventName", {"eventValuesKey1": "eventValuesValue1"});
  });

  test('sendEventWithNoValues', () async {
    await platform.sendEvent("eventName", null);
  });

  test('showInAppMessage', () async {
    await platform.showInAppMessage();
  });

  test('showHome', () async {
    await platform.showHome();
  });

  test('showCampaignWithId', () async {
    await platform.showCampaignWithId("1234");
  });

  test('showCampaignWithType', () async {
    await platform.showCampaignWithType(CampaignType.attendance);
  });
}
