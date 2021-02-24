import 'dart:async';

import 'package:brunch_tools/main.dart';
import 'package:brunch_tools/utilities/WebSocket.dart';
import 'package:brunch_tools/widgets/AppBarFactory.dart';
import 'package:flutter/material.dart';

class Updating extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return UpdatingState();
  }

  static bool needToolkitUpdate() {
    return false;
  }

  static bool needFrameworkUpdate() {
    return false;
  }

  static bool needDaemonUpdate() {
    return false;
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
    WebSocket.getDaemonVersion((str) {
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
