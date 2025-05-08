import 'package:buzz_booster_example/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketingConsentPage extends StatefulWidget {
  const MarketingConsentPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MarketingConsentPage> createState() => _MarketingConsentPage();
}

class _MarketingConsentPage extends State<MarketingConsentPage> {
  bool _isOptInMarketing = false;
  _MarketingConsentPage();

  @override
  void initState() {
    super.initState();
    doAsyncStuff();
  }

  Future<void> doAsyncStuff() async {
    setState(() {});
    _isOptInMarketing = await repository.getIsOptInMarketing();
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MarketingConsent"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_circle_left_rounded),
        ),
      ),
      body: Column(
        children: [
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
          Container(
            color: Colors.white,
            child: OutlinedButton(
              onPressed: () async {
                if (_isOptInMarketing) {
                  await buzzBooster.sendEvent("bb_opt_in_marketing", null);
                } else {
                  await buzzBooster.sendEvent("bb_opt_out_marketing", null);
                }
                showToast("수신 동의: $_isOptInMarketing");
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
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
