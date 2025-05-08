import 'package:flutter/material.dart';
import 'Partner.dart';
import 'Repository.dart';

final repository = Repository();

class AppKeySearchPage extends StatefulWidget {
  const AppKeySearchPage({Key? key}) : super(key: key);

  @override
  State<AppKeySearchPage> createState() => _AppKeySearchPage();
}

class _AppKeySearchPage extends State<AppKeySearchPage> {
  final searchTextController = TextEditingController();

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
        title: Text("Select a App Key"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_circle_left_rounded)),
      ),
      body: FutureBuilder<List<Partner>?>(
        future: repository.getAppKeys(),
        builder: ((context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(color: Colors.white);
          }
          final data = snapshot.data!.where((element) {
            if (searchTextController.text.isNotEmpty) {
              final searchText = searchTextController.text.toLowerCase();
              return element.appKey.toLowerCase().startsWith(searchText) ||
                  element.appName.toLowerCase().startsWith(searchText);
            }
            return true;
          }).toList();
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextController,
                      onChanged: (text) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        searchTextController.text = "";
                        setState(() {});
                      },
                      icon: Icon(Icons.clear_rounded))
                ],
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Partner partner = data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, partner.appKey);
                      },
                      child: Container(
                        height: 30,
                        color: Colors.white,
                        child: Text(
                          "${partner.appKey} ${partner.appName} ${partner.env}",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
