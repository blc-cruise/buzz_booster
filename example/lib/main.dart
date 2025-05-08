import 'package:buzz_booster_example/AppKeySearchPage.dart';
import 'package:buzz_booster_example/FCMService.dart';
import 'package:buzz_booster_example/MarketingConsentPage.dart';
import 'package:buzz_booster_example/Repository.dart';
import 'package:buzz_booster_example/ServerMutator.dart';
import 'package:buzz_booster_example/WebViewPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:buzz_booster/buzz_booster.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final fcmService = FCMService();
final buzzBooster = BuzzBooster();
final repository = Repository();
final serverMutator = ServerMutator();

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://2e629f8df4aa43a52f9246603388f62f@o4459.ingest.sentry.io/4505746007719936';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      Phoenix(
        child: const MaterialApp(home: MyApp()),
      ),
    ),
  );
  await fcmService.initFirebase();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Environment _environment = Environment.Production;
  BuzzBoosterTheme? _theme = BuzzBoosterTheme.system;
  final appKeyTextController = TextEditingController();
  final userIdTextController = TextEditingController();
  final pageIdTextController = TextEditingController();
  String sdkVersion = "";
  bool _isOptInMarketing = false;

  @override
  void initState() {
    super.initState();
    doAsyncStuff();
    buzzBooster.optInMarketingCampaignMoveButtonClickedCallback = () async {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => MarketingConsentPage()));
    };

    buzzBooster.userEventChannel =
        (String userEventName, Map<String, dynamic>? userEventValues) async {
      print("userEventDidOccur: $userEventName $userEventValues");
    };
  }

  Future<void> doAsyncStuff() async {
    sdkVersion = await repository.getSdkVersion();
    _environment = await repository.getServerEnvironment();
    _isOptInMarketing = await repository.getIsOptInMarketing();
    _theme = await repository.getTheme();
    await buzzBooster.setTheme(_theme!);
    print(_environment);
    await serverMutator.changeEnvironment(_environment);
    appKeyTextController.text = await repository.getAppKey();
    userIdTextController.text = await repository.getUserId();
    setState(() {});
    final isBuzzBoosterInitialized = await buzzBooster.isInitialized();
    if (!isBuzzBoosterInitialized) {
      print("buzzBooster is not initialized");
      await buzzBooster.init(
        androidAppKey: await repository.getAndroidAppKey(),
        iosAppKey: await repository.getiOSAppKey(),
      );
    } else {
      var logMessage = "buzzBooster is already initialized SKIP init";
      print(logMessage);
      showToast(logMessage);
    }

    final String? token = await fcmService.getToken();
    if (token != null) {
      await buzzBooster.setPushToken(token);
    }

    await fcmService.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;
      if (await buzzBooster.isBuzzBoosterNotification(data)) {
        await buzzBooster.handleNotification(data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final data = message.data;
      if (await buzzBooster.isBuzzBoosterNotification(data)) {
        await buzzBooster.handleOnMessageOpenedApp(data);
      }
    });

    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      if (await buzzBooster.isBuzzBoosterNotification(message.data)) {
        await buzzBooster.handleInitialMessage(message.data);
      }
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("SDK version: $sdkVersion"),
                appInfoWidget(),
                loginWidget(),
                themeWidget(),
                OutlinedButton(
                    onPressed: () async {
                      await MethodChannel('com.buzzvil.dev/booster')
                          .invokeMethod('showDebugger', {});
                    },
                    child: const Text("network")),
                SizedBox(
                  height: 10,
                ),
                eventWidget(),
                pageWidget(),
                showSpecificCampaignWidget(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await buzzBooster.showHome();
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.gif_box),
        ),
      ),
    );
  }

  Widget appInfoWidget() {
    return Column(children: [
      const Text("This is BuzzBooster Flutter App"),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: appKeyTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'App Key',
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppKeySearchPage()));
                if (result != null) {
                  appKeyTextController.text = result;
                }
              },
              icon: Icon(Icons.search))
        ],
      ),
      TextField(
        controller: userIdTextController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'UserId',
        ),
      ),
      serverMutatorWidget(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Is opt in Marketing"),
          Switch(
            value: _isOptInMarketing,
            onChanged: (value) {
              setState(() {
                _isOptInMarketing = value;
              });
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            onPressed: () async {
              String appKey = appKeyTextController.text;
              String userId = userIdTextController.text;
              await repository.clearCursor(appKey);
              await repository.saveAppKey(appKey, userId);
              await repository.saveServerEnvironment(_environment);
              await repository.saveIsOptInMarketing(_isOptInMarketing);
              if (_theme != null) {
                await repository.saveTheme(_theme!);
              }
              await buzzBooster.setUser(null);
              Phoenix.rebirth(context);
            },
            child: const Text("Restart"),
          ),
          OutlinedButton(
            onPressed: () async {
              bool result = await buzzBooster.isInitialized();
              var logMessage = "buzzBooster.isInitialized $result";
              showToast(logMessage);
              print(logMessage);
            },
            child: const Text("isInitialized"),
          ),
        ],
      ),
    ]);
  }

  StatefulWidget serverMutatorWidget() {
    return DropdownButton<Environment>(
        value: _environment,
        items: Environment.values
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _environment = value!;
          });
        });
  }

  Widget loginWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () async {
                String userId = userIdTextController.text;
                if (userId.isNotEmpty) {
                  showToast("login");
                  User user = UserBuilder(userId)
                      .setOptInMarketing(_isOptInMarketing)
                      .addProperty("key1", "value")
                      .addProperty("key2", true)
                      .addProperty("key3", 2)
                      .build();
                  await buzzBooster.setUser(user);
                  await buzzBooster.showInAppMessage();
                }
              },
              child: const Text("Login"),
            ),
            OutlinedButton(
              onPressed: () async {
                showToast("logout");
                userIdTextController.clear();
                await buzzBooster.setUser(null);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ],
    );
  }

  Widget eventWidget() {
    final eventNameTextController = TextEditingController();
    final eventValuesKeyTextController1 = TextEditingController();
    final eventValuesValueTextController1 = TextEditingController();
    final eventValuesKeyTextController2 = TextEditingController();
    final eventValuesValueTextController2 = TextEditingController();
    final eventValuesKeyTextController3 = TextEditingController();
    final eventValuesValueTextController3 = TextEditingController();
    return Column(children: [
      const Text("Send Event"),
      TextField(
        controller: eventNameTextController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'event name',
        ),
      ),
      eventValueWidget(
          eventValuesKeyTextController1, eventValuesValueTextController1),
      eventValueWidget(
          eventValuesKeyTextController2, eventValuesValueTextController2),
      eventValueWidget(
          eventValuesKeyTextController3, eventValuesValueTextController3),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            onPressed: () async {
              String eventName = eventNameTextController.text;
              if (eventName.isNotEmpty) {
                Map<String, String> eventValues = {};
                if (eventValuesKeyTextController1.text.isNotEmpty) {
                  eventValues[eventValuesKeyTextController1.text] =
                      eventValuesValueTextController1.text;
                }
                if (eventValuesKeyTextController2.text.isNotEmpty) {
                  eventValues[eventValuesKeyTextController2.text] =
                      eventValuesValueTextController2.text;
                }
                if (eventValuesKeyTextController3.text.isNotEmpty) {
                  eventValues[eventValuesKeyTextController3.text] =
                      eventValuesValueTextController3.text;
                }
                await buzzBooster.sendEvent(eventName, eventValues);
                showToast("send event: ${eventName}");
              } else {
                showToast("event name is required");
              }
            },
            child: const Text("Send Event"),
          ),
          OutlinedButton(
            onPressed: () async {
              eventNameTextController.clear();
              eventValuesKeyTextController1.clear();
              eventValuesValueTextController1.clear();
              eventValuesKeyTextController2.clear();
              eventValuesValueTextController2.clear();
              eventValuesKeyTextController3.clear();
              eventValuesValueTextController3.clear();
            },
            child: const Text("Clear Event"),
          ),
        ],
      ),
    ]);
  }

  Widget eventValueWidget(
      TextEditingController eventKeyTEC, TextEditingController eventValueTEC) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: TextField(
            controller: eventKeyTEC,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'event values key',
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: eventValueTEC,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'event values value',
            ),
          ),
        )
      ],
    );
  }

  Widget showSpecificCampaignWidget() {
    return SingleChildScrollView(
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () async {
              await buzzBooster.showCampaignWithType(CampaignType.attendance);
            },
            child: const Text("출첵"),
          ),
          OutlinedButton(
            onPressed: () async {
              await buzzBooster.showCampaignWithType(CampaignType.referral);
            },
            child: const Text("친초"),
          ),
          OutlinedButton(
            onPressed: () async {
              await buzzBooster
                  .showCampaignWithType(CampaignType.optInMarketing);
            },
            child: const Text("마수동"),
          ),
          OutlinedButton(
            onPressed: () async {
              await buzzBooster
                  .showCampaignWithType(CampaignType.scratchLottery);
            },
            child: const Text("긁"),
          ),
          OutlinedButton(
            onPressed: () async {
              await buzzBooster.showCampaignWithType(CampaignType.roulette);
            },
            child: const Text("룰"),
          ),
          OutlinedButton(
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WebViewPage()));
            },
            child: const Text("웹"),
          ),
        ],
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget pageWidget() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: pageIdTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Input Page Id',
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            buzzBooster.showPage(pageIdTextController.text);
          },
          child: const Text("이동"),
        )
      ],
    );
  }

  StatefulWidget themeWidget() {
    Widget buildRadioTile(BuzzBoosterTheme theme, String title,
        Function(void Function()) setState) {
      return Expanded(
        child: ListTile(
          title: Text(title),
          contentPadding: EdgeInsets.all(0),
          leading: Radio(
            value: theme,
            groupValue: _theme,
            onChanged: (BuzzBoosterTheme? value) async {
              print("changed theme: $value");
              if (value != null) {
                await buzzBooster.setTheme(value);
              }
              setState(() {
                _theme = value;
              });
            },
          ),
        ),
      );
    }

    return StatefulBuilder(builder: (context, _setState) {
      return Row(
        children: [
          buildRadioTile(BuzzBoosterTheme.light, 'Light', _setState),
          buildRadioTile(BuzzBoosterTheme.dark, 'Dark', _setState),
          buildRadioTile(BuzzBoosterTheme.system, 'System', _setState),
        ],
      );
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
