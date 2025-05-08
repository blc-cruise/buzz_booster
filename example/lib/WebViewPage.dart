import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:buzz_booster/buzz_booster.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {
  late String _url;
  WebViewController? _controller = null;

  _WebViewPage() {
    if (Platform.isAndroid) {
      _url = "http://10.0.2.2:3000/buzzbooster-web/apps/1234/test";
    } else {
      _url = "http://localhost:3000/buzzbooster-web/apps/1234/test";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final channel = JavascriptChannel(
      name: "BuzzBooster",
      onMessageReceived: (JavascriptMessage message) async {
        BuzzBooster().postJavaScriptMessage(message.message);
      }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_circle_left_rounded),
        ),
      ),
      body: WebView(
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: {channel},
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          onPageFinished:  (String url) async {
            _controller?.runJavascript('''
              const BuzzBoosterJavaScriptInterface = {
                postMessage: function(message) {
                  window.BuzzBooster.postMessage(message);
                }
              };
              ''');
          },
      ),
    );
  }
}
