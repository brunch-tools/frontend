import 'dart:async';

import 'package:brunch_toolkit/main.dart';
import 'package:brunch_toolkit/pages/HomePage.dart';
import 'package:brunch_toolkit/utilities/JsLocalStorage.dart';
import 'package:brunch_toolkit/utilities/WebSocket.dart';
import 'package:brunch_toolkit/widgets/AppBarFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class SetupPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SetupPageState();
  }

}

class SetupPageState extends State<SetupPage> {

  Timer _timer;
  bool _unlockButton = false;
  bool _hasShownOldWarning = false;
  String _version = "NONE";
  String _notice = "The Brunch Toolkit Daemon isn't running yet,\nplease complete setup and come back here.";

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 3), (_timer) { checkSocket();});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkSocket() async {
    WebSocket.getDaemonVersion((str) {
      if(str == null)
        return;
      if(int.parse(str.replaceAll('.', '')) < int.parse(Constants.MIN_VERSION.replaceAll('.', ''))) {
        setState(() {
          _unlockButton = false;
          _version = str;
          _notice = "Your Brunch Toolkit Daemon version, v"+_version+", does not\nmeet the requirements. Please rerun the installer.";
        });
        if(_hasShownOldWarning)
          return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_notice), duration: Duration(seconds: 15),));
        _hasShownOldWarning = true;
      } else {
        setState(() {
          _unlockButton = true;
          _version = str;
          _notice = "Detected Brunch Toolkit Daemon v"+_version;
          _timer.cancel();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_notice), duration: Duration(seconds: 15),));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getBar(context, "Welcome to the Brunch Toolkit", "Automatic Updates and Tweaks"),
      bottomNavigationBar: BottomAppBar (
        elevation: 0.0,
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: MediaQuery.of(context).size.width<995?15:45,
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            Align(
              child: Container(
                child: Tooltip(
                  message: _notice,
                  child: MaterialButton(
                    onPressed: _unlockButton? () {
                      JsLocalStorage.set("is-installed", "true");
                      Navigator.push(context, PageTransition(child: HomePage(), type: PageTransitionType.fade));
                    }:null,
                    child: Text("Next"),
                    color: Theme.of(context).buttonColor,
                    disabledColor: Theme.of(context).disabledColor,
                    autofocus: true,
                    height: 50,
                  ),
                  padding: EdgeInsets.all(10),
                ),
              ),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
      body: AppBarFactory.getPagePadding(
        Center(
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width<1140?1:2,
            childAspectRatio: MediaQuery.of(context).size.width<450?0.3:1.5,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("The best of Brunch is waiting.", overflow: TextOverflow.visible, style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.normal)),
                  Text("1) Press Ctrl+Alt+T", overflow: TextOverflow.visible, style: Theme.of(context).textTheme.headline5),
                  Text("2) Type in \"shell\"", overflow: TextOverflow.visible, style: Theme.of(context).textTheme.headline5),
                  Text("3) Paste the following command, and when it's done, come back to this screen:", overflow: TextOverflow.visible, style: Theme.of(context).textTheme.headline5),
                  GestureDetector(
                    child: Container(
                      child: Text("curl -Ls https://brunch.xeu100.com/install.sh | sudo bash", style: Theme.of(context).textTheme.headline5),
                      color: Colors.black12,
                    ),
                    onTap: () {
                      Clipboard.setData(new ClipboardData(text: "curl -Ls https://brunch.xeu100.com/install.sh | sudo bash"));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Content Copied to Clipboard!")));
                    },
                  )
                ],
              ),
              Container(
                child: Image(image: AssetImage("assets/images/image 1.png")),
                height: 450,
              ),
            ],
          ),
        ),
      )
    );
  }


}