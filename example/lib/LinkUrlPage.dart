import 'package:flutter/material.dart';

class LinkUrlPage extends StatefulWidget {
  final String url;

  const LinkUrlPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<LinkUrlPage> createState() => _LinkUrlPage(url:url);
}

class _LinkUrlPage extends State<LinkUrlPage> {
  final String url;

  _LinkUrlPage({
    required this.url,
  });

  @override
  void initState() {
    super.initState();
    doAsyncStuff();
  }

  Future<void> doAsyncStuff() async {
    setState(() {});
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DeepLink"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_circle_left_rounded),
        ),
      ),
      body: Container(
        height: 30,
        color: Colors.white,
        child: Text(
          "${url}",
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ),
    );
  }
}
