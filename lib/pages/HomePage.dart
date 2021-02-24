import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:brunch_tools/utilities/WebSocket.dart';
import 'package:brunch_tools/widgets/AppBarFactory.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Updating.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {

  Timer _timer;
  bool _unlockButton = false;
  bool _hasShownOldWarning = false;
  String _notice = "Grabbing the latest daemon version!";

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 3), (_timer) { checkSocket();});
    super.initState();
  }

  void checkSocket() async {
    final response = await http.get('./required/latest-version.json');
    Map vers = jsonDecode(response.body);
    WebSocket.getInfo((str) {
      if(str == null)
        return;
      if(int.parse(str["daemon_version"].replaceAll('.', '')) < int.parse(vers["latest"].replaceAll('.', ''))) {
        setState(() {
          _unlockButton = true;
          _notice = "An update to v"+vers["latest"]+" is available!";
          _timer.cancel();
        });
        if(_hasShownOldWarning)
          return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_notice), duration: Duration(seconds: 15),));
        _hasShownOldWarning = true;
      } else {
        setState(() {
          _unlockButton = false;
          _notice = "You're on the latest daemon!";
          _timer.cancel();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_notice), duration: Duration(seconds: 15),));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBar(context, "Welcome to Brunch Tools", "Automatic Updates and Tweaks"),
      bottomNavigationBar: BottomAppBar(
        child: GridView.count(
          crossAxisCount: 1,
          shrinkWrap: true,
          childAspectRatio: MediaQuery.of(context).size.width<995?5:25,
          children: [
            Align(
              child: Container(
                child: Tooltip(
                  message: _notice,
                  child: MaterialButton(
                    onPressed: _unlockButton? () {
                      WebSocket.updateDaemon();
                      _unlockButton = false;
                      _notice = "You're on the latest daemon!";
                      Navigator.push(context, PageTransition(child: Updating(), type: PageTransitionType.fade));
                    }:null,
                    child: Text("Update Daemon"),
                    color: Theme.of(context).buttonColor,
                    disabledColor: Theme.of(context).disabledColor,
                    autofocus: true,
                    height: 50,
                  ),
                  padding: EdgeInsets.all(10),
                ),
              ),
              alignment: Alignment.center,
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: ListView(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Coming soon to an in between meal near you.", textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline4),
                  Text("You’re all caught up on all you can do, so feel free to wait while we roll out\nthe red carpet.\n\nIn the mean time, if there’s an update available to you, that button will\nactivate! When you press it, you’ll be taken to the update page.", style: Theme.of(context).textTheme.headline5)
                ],
              ),
            ),
          ],
          shrinkWrap: true,
        )
      )
    );
  }

}