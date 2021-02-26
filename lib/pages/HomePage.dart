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

  @override
  void initState() {
    super.initState();
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
                  message: "Go to the Update management page!",
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context, PageTransition(child: Updating(), type: PageTransitionType.fade));
                    },
                    child: Text("Check for Updates"),
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