import 'dart:async';

import 'package:brunch_toolkit/pages/SetupPage.dart';
import 'package:brunch_toolkit/utilities/JsCommons.dart';
import 'package:brunch_toolkit/utilities/JsLocalStorage.dart';
import 'package:brunch_toolkit/widgets/AppBarFactory.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class InstallAsPWA extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return InstallAsPWAState();
  }

}

class InstallAsPWAState extends State<InstallAsPWA> {

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkForPWA());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkForPWA() {
    if(JsCommons.isStandalone() || JsLocalStorage.get("debug-mode") == "true") {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(PageTransition(child: SetupPage(), type: PageTransitionType.fade));
      });
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBar(context, "Welcome to the Brunch Toolkit", "Automatic Updates and Tweaks"),
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
                child: Text("Please install this website\nas a PWA to continue.", overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center,),
                alignment: MediaQuery.of(context).size.width<995?Alignment.topCenter:Alignment.centerLeft,
              ),
            ],
          )
        )
      )
    );
  }


}
