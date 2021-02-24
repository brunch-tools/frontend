import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:brunch_tools/main.dart';
import 'package:brunch_tools/utilities/WebSocket.dart';
import 'package:brunch_tools/widgets/AppBarFactory.dart';
import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool);

class Updating extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return UpdatingState();
  }

  static void needsToolkitUpdate(BoolCallback callback) {
    WebSocket.getInfo((str) async {
      if(str == null)
        callback(false);
      if(str["toolkit_version"] == "NONE")
        callback(true);
      int localVersion = int.parse(str["toolkit_version"].replaceAll(".",""));
      int serverVersion = 0;
      final response = await http.get('https://raw.githubusercontent.com/WesBosch/brunch-toolkit/main/brunch-toolkit');
      for(String s in response.body.split("\n")) {
        if(s.startsWith("TOOLVER=")) {
          serverVersion=int.parse(s.replaceAll("TOOLVER=\"v", "").replaceAll(RegExp(r'."'), "").replaceAll(".", ""));
        }
      }
      callback(localVersion < serverVersion);
    });
  }

  static void needsFrameworkUpdate(BoolCallback callback) {
    WebSocket.getInfo((str) async {
      if(str == null)
        callback(false);
      if(str["brunch_version"] == "NONE")
        callback(false);
      final response = await http.get('https://api.github.com/repos/sebanc/brunch/releases/latest');
      int localVersion = int.parse(str["brunch_version"].replaceFirst("Brunch r","").replaceFirst(RegExp(r'[0-9][0-9] '),""));
      int serverVersion = int.parse(jsonDecode(response.body)["name"].replaceFirst("Brunch r","").replaceFirst(RegExp(r'[0-9][0-9] stable '),""));
      callback(localVersion < serverVersion);
    });
  }

  static void needsDaemonUpdate(BoolCallback callback) {
    WebSocket.getInfo((str) async {
      if(str == null)
        callback(false);
      final response = await http.get('https://api.github.com/repos/brunch-tools/daemon/releases/latest');
      int localVersion = int.parse(str["daemon_version"].replaceAll(".",""));
      int serverVersion = int.parse(jsonDecode(response.body)["name"].replaceFirst("Release v","").replaceAll(".",""));
      print(localVersion.toString()+" "+serverVersion.toString());
      callback(localVersion < serverVersion);
    });
  }

}

class UpdatingState extends State<Updating> {

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkSocket());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkSocket() async {
    if(!Register.daemonUpdateComplete)
      return;
    WebSocket.getInfo((str) {
      if(str == null)
        return;
      timer.cancel();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBar(context, "An update is in progress.", "Brunch Tools will automatically reconnect when complete."),
      body: AppBarFactory.getPagePadding(
        Center(
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width<995?1:2,
            childAspectRatio: MediaQuery.of(context).size.width<995?3:2,
            shrinkWrap: true,
            children: [
              Container(
                child: Image(image: AssetImage("assets/images/alert-illustration_2x 1.png")),
              ),
              Align(
                child: Text("The daemon has automatically began to\nupdate, this should only take a few minutes.\n\nSit back and relax, you'll be taken back to your previous\nscreen when a connection is available.", overflow: TextOverflow.visible, textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline5),
                alignment: MediaQuery.of(context).size.width<995?Alignment.topCenter:Alignment.centerLeft,
              ),
            ],
          )
        )
      )
    );
  }


}
