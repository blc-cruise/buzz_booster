import 'package:buzz_booster/buzz_booster.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'buzz_booster_method_channel.dart';

abstract class BuzzBoosterPlatform extends PlatformInterface {
  BuzzBoosterPlatform() : super(token: _token);

  static final Object _token = Object();

  static BuzzBoosterPlatform _instance = MethodChannelBuzzBooster();

  static BuzzBoosterPlatform get instance => _instance;

  static set instance(BuzzBoosterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setUser(User? user, ) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init(
      {required String androidAppKey, required String iosAppKey}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> isInitialized() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> sendEvent(
    String eventName,
    Map<String, Object>? eventValues,
  ) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showInAppMessage() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showHome() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setPushToken(String token) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> isBuzzBoosterNotification(Map<String, dynamic> map) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> handleNotification(Map<String, dynamic> map) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> handleInitialMessage(Map<String, dynamic> data) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  
  Future<void> handleOnMessageOpenedApp(Map<String, dynamic> data) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  
  Future<void> showCampaignWithId(String campaignId) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showCampaignWithType(CampaignType campaignType) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showNaverPayExchange() {
    throw UnimplementedError('showNaverPayExchange() has not been implemented.');
  }

  Future<void> showPage(String pageId) {
    throw UnimplementedError('showPage() has not been implemented.');
  }

  Future<void> setTheme(BuzzBoosterTheme theme) {
    throw UnimplementedError('setTheme() has not been implemented.');
  }

  Stream<MapEntry<NativeEvent, dynamic>> get eventStream => throw UnimplementedError(
      'getEventStream has not been implemented on the current platform.');

  Stream<void> get optInMarketinCampaignMoveButtonClickedEventStream => throw UnimplementedError(
      'getEventStream has not been implemented on the current platform.');

  Future<void> postJavaScriptMessage(String message) {
    throw UnimplementedError('postJavaScriptMessage has not been implemented.');
  }
}
